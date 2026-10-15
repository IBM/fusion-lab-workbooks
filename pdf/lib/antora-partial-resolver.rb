# antora-partial-resolver.rb
#
# Asciidoctor include processor for standalone PDF builds.
# Intercepts Antora-style family references and resolves them to real paths:
#
#   include::partial$foo.adoc[]        -> <partials-dir>/foo.adoc
#   include::example$scripts/bar.sh[]  -> <examples-dir>/scripts/bar.sh
#
# Nav footer partials (partial$nav-*) are suppressed so the
# Previous / Next navigation tables do not appear in PDF output.
#
# Activated via: asciidoctor-pdf -r ./pdf/lib/antora-partial-resolver.rb

require 'asciidoctor'
require 'asciidoctor/extensions'

Asciidoctor::Extensions.register do
  include_processor do
    handles? do |target|
      target.start_with?('partial$') || target.start_with?('example$')
    end

    process do |doc, reader, target, attrs|
      partials_dir = doc.attr('partials-dir', '')
      examples_dir = doc.attr('examples-dir', '')

      # Derive examples-dir from partials-dir if not explicitly set
      if examples_dir.empty? && !partials_dir.empty?
        examples_dir = File.join(File.dirname(partials_dir), 'examples')
      end

      if target.start_with?('partial$nav-')
        # Suppress nav footer partials — web navigation only, not needed in PDF
        reader.push_include('', target, target, 1, attrs)

      elsif target.start_with?('partial$')
        filename = target[8..]  # strip 'partial$'
        path = File.join(partials_dir, filename)
        if File.exist?(path)
          reader.push_include(File.read(path), path, path, 1, attrs)
        else
          warn "antora-partial-resolver: partial not found: #{path}"
          reader.push_include('', target, target, 1, attrs)
        end

      elsif target.start_with?('example$')
        filename = target[8..]  # strip 'example$'
        path = File.join(examples_dir, filename)
        if File.exist?(path)
          reader.push_include(File.read(path), path, path, 1, attrs)
        else
          warn "antora-partial-resolver: example not found: #{path}"
          reader.push_include('', target, target, 1, attrs)
        end
      end
    end
  end
end
