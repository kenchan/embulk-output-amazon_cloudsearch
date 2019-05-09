require 'aws-sdk-cloudsearchdomain'

module Embulk
  module Output

    class AmazonCloudsearch < OutputPlugin
      Plugin.register_output("amazon_cloudsearch", self)


      def self.transaction(config, schema, count, &control)
        # configuration code:
        task = {
          'endpoint' => config.param('endpoint', :string),
          'id_column' => config.param('id_column', :string),
          'upload_columns' => config.param('upload_columns', :array),
          'stub_response' => config.param('stub_response', :bool, default: false)
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
        @id_column = task['id_column']
        @upload_columns = task['upload_columns']
        @stub_response = task['stub_response']
      end

      def close
      end

      def add(page)
        # output code:
        page.each do |record|
          hash = Hash[schema.names.zip(record)]

          fields = @upload_columns.map {|c| %["#{c}": "#{hash[c]}"] }

          client.upload_documents(
            documents: <<~JSON,
              [
                {
                  "type": "add",
                  "id": "#{hash[@id_column]}",
                  "fields": { #{fields.join(",")} }
                }
              ]
            JSON
            content_type: 'application/json'
          )
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

      private
      def client
        @_client ||= c = Aws::CloudSearchDomain::Client.new(endpoint: @endpoint, stub_responses: @stub_response)
      end
    end
  end
end
