#!/bin/bash
# targetcli iSCSI Target Configuration Script for IBM Storage Scale Node
# Run on the Scale node as root
#
# Environment variables (with defaults matching fusion-access-san-attrs.adoc):
#   SCALE_FS_MOUNT       - Scale filesystem mount point (default: /scale/fs1)
#   SCALE_FS_NAME        - Scale filesystem name (default: fs1)
#   ISCSI_TARGET_IQN     - iSCSI target IQN (default: iqn.2022-06.com.scale.scalenode1:tgt0)
#   ISCSI_TARGET_PORT    - iSCSI target port (default: 3260)
#   LUN_SIZE             - LUN size (default: 500G)
#   LUN_COUNT            - Number of LUNs to create (default: 2)
#   SCALE_SSH_USER       - SSH user for Scale node (default: root)

set -e

: "${SCALE_FS_MOUNT:=/scale/fs1}"
: "${SCALE_FS_NAME:=fs1}"
: "${ISCSI_TARGET_IQN:=iqn.2022-06.com.scale.scalenode1:tgt0}"
: "${ISCSI_TARGET_PORT:=3260}"
: "${LUN_SIZE:=500G}"
: "${LUN_COUNT:=2}"
: "${SCALE_SSH_USER:=root}"

echo "=== targetcli iSCSI Target Configuration ==="
echo "Using SCALE_FS_MOUNT=${SCALE_FS_MOUNT}, ISCSI_TARGET_IQN=${ISCSI_TARGET_IQN}, ISCSI_TARGET_PORT=${ISCSI_TARGET_PORT}, LUN_SIZE=${LUN_SIZE}, LUN_COUNT=${LUN_COUNT}"

# Install required packages
echo "Installing targetcli and iscsi-initiator-utils..."
yum install -y targetcli
dnf install -y iscsi-initiator-utils

# Configure firewall
echo "Configuring firewall for iSCSI port ${ISCSI_TARGET_PORT}..."
firewall-cmd --permanent --add-port ${ISCSI_TARGET_PORT}/tcp
systemctl restart firewalld
firewall-cmd --list-ports

# Create backing store files on Scale filesystem
echo "Creating backing store files on ${SCALE_FS_MOUNT}..."
for i in $(seq 0 $((LUN_COUNT - 1))); do
  targetcli /backstores/fileio create iscsilun${i} ${SCALE_FS_MOUNT}/iscsilun${i} ${LUN_SIZE}
done

echo "Verifying backing stores..."
targetcli /backstores/fileio ls

# Create iSCSI target IQN
echo "Creating iSCSI target IQN..."
targetcli /iscsi create ${ISCSI_TARGET_IQN}

# Configure Target Portal Group (TPG)
echo "Configuring Target Portal Group..."
targetcli /iscsi/${ISCSI_TARGET_IQN}/tpg1 set attribute authentication=0
targetcli /iscsi/${ISCSI_TARGET_IQN}/tpg1 set attribute generate_node_acls=1

# Create LUNs
echo "Creating LUNs..."
for i in $(seq 0 $((LUN_COUNT - 1))); do
  targetcli /iscsi/${ISCSI_TARGET_IQN}/tpg1/luns create /backstores/fileio/iscsilun${i}
done

echo "Verifying LUNs..."
targetcli /iscsi/${ISCSI_TARGET_IQN}/tpg1/luns ls

# Create ACLs for worker nodes (replace IQNs with actual values from initiators)
echo "Creating ACLs for worker nodes..."
echo "NOTE: Replace <worker1-iqn>, <worker2-iqn>, <worker3-iqn> with actual IQNs from initiators"
echo "Run this script after obtaining IQNs from worker nodes, or manually create ACLs:"
for i in 1 2 3; do
  echo "  targetcli /iscsi/${ISCSI_TARGET_IQN}/tpg1/acls create iqn.1994-05.com.redhat:<worker${i}-iqn>"
done

# Set file permissions
echo "Setting file permissions on backing store files..."
chmod 777 ${SCALE_FS_MOUNT}/iscsilun*
ls -al ${SCALE_FS_MOUNT}/iscsilun*

# Verify target service
echo "Verifying target service is listening on port ${ISCSI_TARGET_PORT}..."
netstat -an | grep ${ISCSI_TARGET_PORT}

# Save configuration
echo "Saving targetcli configuration..."
targetcli saveconfig

echo "=== targetcli Configuration Complete ==="
echo "Configuration saved to /etc/target/saveconfig.json"
echo ""
echo "Next steps:"
echo "1. Run iSCSI discovery on worker nodes: iscsiadm -m discovery -t sendtargets -p <scale-node-ip>"
echo "2. Login to target: iscsiadm -m node -T ${ISCSI_TARGET_IQN} -p <scale-node-ip> -l"
echo "3. Verify LUNs: lsblk"