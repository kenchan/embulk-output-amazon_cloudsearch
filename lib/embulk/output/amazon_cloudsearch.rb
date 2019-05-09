require 'aws-sdk-cloudsearchdomain'

module Embulk
  module Output

    class AmazonCloudsearch < OutputPlugin
      Plugin.register_output("amazon_cloudsearch", self)


      def self.transaction(config, schema, count, &control)
        # configuration code:
        task = {
          'endpoint' => config.param('endpoint', :string)
        }

        # resumable output:
        # resume(task, schema, count, &control)

        # non-resumable output:
        task_reports = yield(task)
        next_config_diff = {}
        return next_config_diff
      end

      # def self.resume(task, schema, count, &control)
      #   task_reports = yield(task)
      #
      #   next_config_diff = {}
      #   return next_config_diff
      # end

      def init
        @endpoint = task['endpoint']
      end

      def close
      end

      def add(page)
        # output code:
        page.each do |record|
          #hash = Hash[schema.names.zip(record)]
        end
      end

      def finish
      end

      def abort
      end

      def commit
        task_report = {}
        return task_report
      end
    end

  end
end
