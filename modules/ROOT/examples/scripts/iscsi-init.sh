#!/bin/bash
# iSCSI Initiator Configuration Script for OpenShift Worker Nodes
# Run from bastion with oc CLI configured
#
# Environment variables (with defaults matching fusion-access-san-attrs.adoc):
#   SSH_KEY_PATH       - SSH private key path (default: /tmp/ocp/cluster/id_rsa)
#   BASTION_USER       - SSH user for worker nodes (default: core)
#   WORKER_NODE_PREFIX - Worker node name prefix for filtering (default: worker-)

set -e

: "${SSH_KEY_PATH:=/tmp/ocp/cluster/id_rsa}"
: "${BASTION_USER:=core}"
: "${WORKER_NODE_PREFIX:=worker-}"

echo "=== iSCSI Initiator Configuration for Worker Nodes ==="
echo "Using SSH_KEY_PATH=${SSH_KEY_PATH}, BASTION_USER=${BASTION_USER}, WORKER_NODE_PREFIX=${WORKER_NODE_PREFIX}"

# 1. Enable multipath on all worker nodes
echo "Enabling multipath on worker nodes..."
for WORKER in $(oc get nodes | grep "${WORKER_NODE_PREFIX}" | awk '{print $1}'); do
  echo "  Configuring $WORKER..."
  ssh -i "${SSH_KEY_PATH}" "${BASTION_USER}@$WORKER" sudo mpathconf --enable
done

# 2. Enable and start iSCSI service on all worker nodes
echo "Enabling iSCSI service on worker nodes..."
for WORKER in $(oc get nodes | grep "${WORKER_NODE_PREFIX}" | awk '{print $1}'); do
  echo "  Enabling iscsi on $WORKER..."
  ssh -i "${SSH_KEY_PATH}" "${BASTION_USER}@$WORKER" sudo systemctl enable iscsi
done

for WORKER in $(oc get nodes | grep "${WORKER_NODE_PREFIX}" | awk '{print $1}'); do
  echo "  Starting iscsi on $WORKER..."
  ssh -i "${SSH_KEY_PATH}" "${BASTION_USER}@$WORKER" sudo systemctl start iscsi
done

# 3. Get IQNs from worker nodes
echo "Retrieving IQNs from worker nodes..."
for WORKER in $(oc get nodes | grep "${WORKER_NODE_PREFIX}" | awk '{print $1}'); do
  echo "  $WORKER IQN:"
  ssh -i "${SSH_KEY_PATH}" "${BASTION_USER}@$WORKER" sudo cat /etc/iscsi/initiatorname.iscsi
done

echo "=== iSCSI Initiator Configuration Complete ==="
echo "Next: Configure iSCSI target on Scale node using targetcli"