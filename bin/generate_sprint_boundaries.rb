#! /usr/bin/env ruby

require "pathname"
require "yaml"

def sprints
  Enumerator.new do |y|
    number, start_date, end_date = nil
    old_milestones = YAML.load_file(Pathname.new(__dir__).join("old_sprint_boundaries.yml"))

    loop do
      if old_milestones.any?
        number, start_date, end_date = old_milestones.shift
      else
        number += 1
        start_date = end_date + 1 # 1 day

        end_date += 14 # 2 weeks
        while (end_date.month == 12 && (22..31).cover?(end_date.day)) ||
              (end_date.month == 1 && (1..4).cover?(end_date.day))
          end_date += 7 # 1 week
        end
      end

      y << [number, start_date, end_date]
    end
  end
end

contents = <<~EOS
  # Sprint Boundaries

  Use the table below to look up which sprint a pull request was merged in.

  Sprint|Start|End|Merged PRs
  ---|---|---|---
EOS
sprints
  .take_while { |_number, start_date, _end_date| start_date < Date.today }
  .reverse
  .each do |number, start_date, end_date|
    contents << [
      number,
      start_date,
      end_date,
      "[link](https://github.com/issues?utf8=%E2%9C%93&q=org%3AManageiq+merged%3A#{start_date}..#{end_date})"
    ].join("|") << "\n"
  end

Pathname.new(__dir__).join("..", "sprint_boundaries.md").write(contents)
