<% if current_user %>
<pre>GET <%= api_v1_policy_url(format: "json", id: "foo", key: current_user.api_key).gsub("foo", "[id]") %></pre>
<% else %>
<pre>GET <%= api_v1_policy_url(format: "json", id: "id2", key: "api_key2").gsub("id2", "[id]").gsub("api_key2", "[api_key]") %></pre>
<% end %>

<% if current_user %>
For example

<pre>GET <%= link_to api_v1_policy_url(format: "json", id: 1, key: current_user.api_key), api_v1_policy_url(format: "json", id: 1, key: current_user.api_key) %></pre>
<% end %>

Це повертає всі види корисної деталізованої інформації, що включают:

Параметр             | Опис
-------------------- | ------------------------------------------------------------------------
`id`                 | Унікальний визначник для голосування. Використовуй id, щоб отримати більше інформації про політику.
`name`               | Коротка назва політики
`description`        | Більше інформації про те, що означає політика
`provisional`        | `true` or `false`. A provisional policy isn't yet "complete" and isn't visible by default in comparisons with people
`policy_divisions`   | Сукупність олосувань, які включені до цієї політики. Кожне голосування має відповідне `vote` яке може бути `strong` і робить голосування дуже важливим
`people_comparisons` | An array of people who could have voted on this division and their calculated `agreement` score in range from 0 to 100. `voted` says whether they ever vote on a division from this policy.
