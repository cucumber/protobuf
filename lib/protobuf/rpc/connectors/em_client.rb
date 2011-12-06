# Handles client connections to the server
module Protobuf
  module Rpc
    module Connectors
    
      class EMClient < EM::Connection
        include Protobuf::Logger::LogMethods
        include Protobuf::Rpc::Connectors::Common
      
        attr_reader :options, :request, :response
        attr_reader :error, :error_reason, :error_message
      
        class << self

          def connect(options={})
            options = DEFAULT_OPTIONS.merge(options)
            Protobuf::Logger.debug '[client-cnxn] Connecting to server: %s' % options.inspect
#            socket = TCPSocket.new(options[:host], options[:port])
#            EM.attach(socket, self, socket, options)
            EM.connect(options[:host], options[:port], self, nil, options)
          end

        end
        
        # Called after the EM.connect
        def connection_completed
          log_debug '[client-cnxn] Established server connection, sending request'
          _send_request unless error?
#          @socket.close_write
        rescue
          fail(:RPC_ERROR, 'Connection error: %s' % $!.message)
        end
      
        def initialize(socket, options={}, &failure_cb)
          @socket = socket
          @failure_cb = failure_cb
          @options = DEFAULT_OPTIONS.merge(options)
          verify_options

          log_debug '[client-cnxn] Client Initialized: %s' % options.inspect
          @success_cb = nil

          initialize_stats
        rescue
          fail(:RPC_ERROR, 'Failed to initialize connection: %s' % $!.message) unless failed?
        end

        # Success callback registration
        def on_success(&success_cb)
          @success_cb = success_cb
        end
      
        # Failure callback registration
        def on_failure(&failure_cb)
          @failure_cb = failure_cb
        end
      
        # Completion callback registration
        def on_complete(&complete_cb)
          @complete_cb = complete_cb
        end
      
        def receive_data(data)
          log_debug '[client-cnxn] receive_data: %s' % data
          @buffer << data
          parse_response if @buffer.flushed?
        end
     
      end
    end
  end
end
