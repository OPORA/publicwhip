<% if current_user %>
<pre>GET <%= link_to api_v1_policies_url(format: "json", key: current_user.api_key), api_v1_policies_url(format: "json", key: current_user.api_key) %></pre>
<% else %>
<pre>GET <%= api_v1_policies_url(format: "json", key: "api_key2").gsub("api_key2", "[api_key]") %></pre>
<% end %>

Це видає базову інформацію про політики, включаючи:

Параметр      | Описання
------------- | -----------------------------------------------------------
`id`          | Унікальний визначник для політики. Використовуй `id`, щоб отримати більше інформації про цю політику. 
`name`        | Коротка назва політики
`description` | Більше деталей про те, що означає ця політика
`provisional` | `true` or `false`. A provisional policy isn't yet "complete" and isn't visible by default in comparisons with people
