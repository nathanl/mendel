require_relative 'base'
require 'colorize'

module Mendel
  module Visualizers
    class ASCII < Base

      def initialize(*args)
        super
        @point_width = 8
      end

      def output
        horizontal_space = '  '
        output_lines = []
        grid.each_with_index do |line, y|
          x_label = axis_label_for(list1[y])
          line_string = x_label
          points_on_line = line.each_with_index.map { |column, x|
            grid_point_for(*grid[y][x])
          }
          line_string.concat(points_on_line.join(horizontal_space))
          output_lines.unshift(line_string)
        end
        y_labels = list2.map {|item| axis_label_for(item) }

        footer_line  = "#{fix_point_width('')}#{y_labels.join(horizontal_space)}"
        output_lines = output_lines.join("\n\n\n")
        output_lines.concat("\n#{footer_line}\n")
      end

      def axis_label_for(list_item)
        fix_point_width(list_item.to_s)
      end

      def grid_point_for(status, score=nil)
        case status
        when :unscored then fix_point_width('')
        when :scored   then fix_point_width(score.to_s).green
        when :returned then fix_point_width(score.to_s).blue
        else raise UnknownPointType, status.inspect
        end
      end

      def fix_point_width(string)
        string[0...point_width].rjust(point_width, ' ')
      end

      private

      attr_reader :point_width
    end
  end
end
