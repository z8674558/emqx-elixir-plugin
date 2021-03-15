##--------------------------------------------------------------------
## Copyright (c) 2021 EMQ Technologies Co., Ltd. All Rights Reserved.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##--------------------------------------------------------------------


defmodule EmqxElixirPlugin.Body do
    
    def hook_add(a, b, c) do
        :emqx_hooks.add(a, b, c)
    end
    
    def hook_del(a, b) do
        :emqx_hooks.del(a, b)
    end

    def load(env) do
        # uncomment the hooks that you want, and implement its callback
        
        #hook_add(:"client.authenticate",  &EmqxElixirPlugin.Body.on_client_authenticate/2, [env])
        #hook_add(:"client.check_acl",     &EmqxElixirPlugin.Body.on_client_check_acl/5,    [env])
        hook_add(:"message.publish",      &EmqxElixirPlugin.Body.on_message_publish/2,     [env])
        #hook_add(:"message.dropped",      &EmqxElixirPlugin.Body.on_message_dropped/4,     [env])
        #hook_add(:"message.deliver",      &EmqxElixirPlugin.Body.on_message_deliver/3,     [env])
        #hook_add(:"message.acked",        &EmqxElixirPlugin.Body.on_message_acked/3,       [env])
        hook_add(:"client.connected",     &EmqxElixirPlugin.Body.on_client_connected/3,    [env])
        #hook_add(:"client.subscribe",     &EmqxElixirPlugin.Body.on_client_subscribe/3,    [env])
        #hook_add(:"client.unsubscribe",   &EmqxElixirPlugin.Body.on_client_unsubscribe/3,  [env])
        #hook_add(:"client.disconnected",  &EmqxElixirPlugin.Body.on_client_disconnected/3, [env])
        #hook_add(:"session.subscribed",   &EmqxElixirPlugin.Body.on_session_subscribed/4,  [env])
        #hook_add(:"session.unsubscribed", &EmqxElixirPlugin.Body.on_session_unsubscribed/4,[env])
    end

    def unload do
        # uncomment the hooks that you want

        #hook_del(:"client.authenticate",  &EmqxElixirPlugin.Body.on_client_authenticate/2 )
        #hook_del(:"client.check_acl",     &EmqxElixirPlugin.Body.on_client_check_acl/5    )
        hook_del(:"message.publish",      &EmqxElixirPlugin.Body.on_message_publish/2     )
        #hook_del(:"message.dropped",      &EmqxElixirPlugin.Body.on_message_dropped/4     )
        #hook_del(:"message.deliver",      &EmqxElixirPlugin.Body.on_message_deliver/3     )
        #hook_del(:"message.acked",        &EmqxElixirPlugin.Body.on_message_acked/3       )
        hook_del(:"client.connected",     &EmqxElixirPlugin.Body.on_client_connected/3    )
        #hook_del(:"client.subscribe",     &EmqxElixirPlugin.Body.on_client_subscribe/3    )
        #hook_del(:"client.unsubscribe",   &EmqxElixirPlugin.Body.on_client_unsubscribe/3  )
        #hook_del(:"client.disconnected",  &EmqxElixirPlugin.Body.on_client_disconnected/3 )
        #hook_del(:"session.subscribed",   &EmqxElixirPlugin.Body.on_session_subscribed/4  )
        #hook_del(:"session.unsubscribed", &EmqxElixirPlugin.Body.on_session_unsubscribed/4)
    end

    def on_client_authenticate(credentials, _env) do
        IO.inspect(["elixir on_client_authenticate", credentials])

        {:stop, Map.put(credentials, :auth_result, :success)}
    end

    def on_client_check_acl(credentials, pubsub, topic, defult_result, _env) do
        IO.inspect(["elixir on_client_check_acl", credentials, pubsub, topic, defult_result])

        {:stop, :allow}
    end
    
    def on_message_publish(msg, _env) do
        m_msg = :emqx_message.to_map(msg)
        case Map.get(:topic, m_msg) do
            #ignore SYS messages
            "$SYS" <> _ ->
                {:ok, msg}
            _ ->
                new_msg = :emqx_message.to_message(%{m_msg | from: "modified"})
                IO.inspect(["elixir on_message_publish", new_msg])
                {:ok, new_msg}
        end
    end

    def on_message_dropped(msg, _by = %{node: node}, reason, _env) do
        m_msg = :emqx_message.to_map(msg)
        case Map.get(:topic, m_msg) do
          #ignore SYS messages
            "$SYS" <> _ ->
                :ok
            _ ->
                IO.inspect(["elixir on_message_dropped", :emqx_message.format(msg), node, reason])
                :ok
        end
    end

    def on_message_deliver(credentials, message, _env) do
        IO.inspect(["elixir on_message_deliver", credentials, message])

        # add your elixir code here

        :ok
    end
    
    def on_message_acked(credentials, message, _env) do
        IO.inspect(["elixir on_message_acked", credentials, message])
        
        # add your elixir code here
        
        :ok
    end
    
    def on_client_connected(clientinfo, conninfo, _env) do
        IO.inspect(["elixir on_client_connected", clientinfo])

        # add your elixir code here

        :ok
    end
    
    def on_client_disconnected(credentials, reasoncode, _env) do
        IO.inspect(["elixir on_client_disconnected", credentials, reasoncode])
        
        # add your elixir code here
        
        :ok
    end
    
    def on_client_subscribe(credentials, topictable, _env) do
        IO.inspect(["elixir on_client_subscribe", credentials, topictable])
        
        # add your elixir code here
        
        {:ok, topictable}
    end
    
    def on_client_unsubscribe(credentials, topictable, _env) do
        IO.inspect(["elixir on_client_unsubscribe", credentials, topictable])
        
        # add your elixir code here
        
        {:ok, topictable}
    end
    
    def on_session_subscribed(credentials, topic, subopts, _env) do
        IO.inspect(["elixir on_session_subscribed", credentials, topic, subopts])
        
        # add your elixir code here
        
        {:ok, subopts}
    end
    
    def on_session_unsubscribed(credentials, topic, opts, _env) do
        IO.inspect(["elixir on_session_unsubscribed", credentials, topic, opts])
        
        # add your elixir code here
        
        {:ok, opts}
    end
end

