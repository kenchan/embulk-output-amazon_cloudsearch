require 'json'
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
          'stub_response' => config.param('stub_response', :bool, default: false),
          'batch_size' => config.param('batch_size', :integer, default: 1000)
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
        @batch_size = task['batch_size']
      end

      def close
      end

      def add(page)
        # output code:
        page.each_slice(@batch_size) do |records|
          documents = records.map do |record|
            hash = Hash[schema.names.zip(record)]

            {
              type: "add",
              id: hash[@id_column].to_s,
              fields: @upload_columns.inject({}) {|acc, c|
                acc[c] = hash[c] if hash[c]
                acc
              }
            }
          end

          begin
            res = client.upload_documents(
              documents: documents.to_json,
              content_type: 'application/json'
            )
          rescue => e
            Embulk.logger.error { "embulk-output-amazon_cloudsearch: #{e}" }
            Embulk.logger.error { "embulk-output-amazon_cloudsearch: id #{documents.first[:id]}-#{documents.last[:id]}, response #{res}" }
          else
            Embulk.logger.debug { "embulk-output-amazon_cloudsearch: response #{res}" }

            unless res.status == 'success'
              Embulk.logger.error { "embulk-output-amazon_cloudsearch: id #{documents.first[:id]}-#{documents.last[:id]}, response #{res}" }
            end
            if res.warnings
              Embulk.logger.warn { "embulk-output-amazon_cloudsearch: id #{documents.first[:id]}-#{documents.last[:id]}, response #{res}" }
            end
          end
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
