<% if current_user %>
<pre>GET <%= api_v1_person_url(format: "json", id: "foo", key: current_user.api_key).gsub("foo", "[id]") %></pre>
<% else %>
<pre>GET <%= api_v1_person_url(format: "json", id: "id2", key: "api_key2").gsub("id2", "[id]").gsub("api_key2", "[api_key]") %></pre>
<% end %>

<% if current_user %>
Наприклад

<pre>GET <%= link_to api_v1_person_url(format: "json", id: 10001, key: current_user.api_key), api_v1_person_url(format: "json", id: 10001, key: current_user.api_key) %></pre>
<% end %>

Це видає всю корисну і деталізовану інформацію, яка включає в себе:

Параметр             | Опис
-------------------- | -----------------------------------------------------------
`rebellions`         | Кількість разів, коли вони голосували проти лінії фракції
`votes_attended`     | Загальну кількість голосувань депутата
`votes_possible`     | Кількість можливих голосувань, де вони могли б голосувати
`offices`            | An array of current ministerial (or shadow ministerial) positions
`policy_comparisons` | An array of policies that this person could have voted on and their calculated `agreement` score in range from 0 to 100. `voted` says whether they ever vote on a division from this policy.
