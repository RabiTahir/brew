# frozen_string_literal: true

require "rubocops/extend/formula"

module RuboCop
  module Cop
    module FormulaAudit
      # This cop audits `uses_from_macos` dependencies in formulae
      class UsesFromMacos < FormulaCop
        ALLOWED_USES_FROM_MACOS_DEPS = %w[
          bison
          bzip2
          curl
          expat
          expect
          flex
          groff
          libffi
          libxml2
          libxslt
          ncurses
          m4
          perl
          php
          python@2
          ruby
          sqlite
          texinfo
          unzip
          vim
          xz
          zlib
          zsh
        ].freeze

        def audit_formula(_node, _class_node, _parent_class_node, body_node)
          find_method_with_args(body_node, :uses_from_macos, /^"(.+)"/).each do |method|
            dep = if parameters(method).first.class == RuboCop::AST::StrNode
              parameters(method).first
            elsif parameters(method).first.class == RuboCop::AST::HashNode
              parameters(method).first.keys.first
            end

            next if ALLOWED_USES_FROM_MACOS_DEPS.include?(string_content(dep))

            problem "`uses_from_macos` should only be used for macOS dependencies, not #{string_content(dep)}."
          end
        end
      end
    end
  end
end
