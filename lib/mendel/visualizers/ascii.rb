require_relative 'base'

module Mendel
  module Visualizers
    class ASCII < Base

      def initialize(*args)
        super
        @label_length = 8
      end

      def axis_label_for(list_item)
        list_item.to_s.rjust(label_length, ' ')[0...label_length]
      end

      def output
        output_lines = []
        grid.each_with_index do |line, index|
          x_label = axis_label_for(list1[index])
          line = "#{x_label}" # add grid line
          output_lines.unshift(line)
        end
        y_labels = list2.map {|item| axis_label_for(item) }
        footer_line = y_labels.join('  ')
        output_lines = output_lines.join("\n\n\n")
        output_lines.concat("\n#{axis_label_for('')}#{footer_line}\n")
      end

      private

      attr_reader :label_length

    end
  end
end
