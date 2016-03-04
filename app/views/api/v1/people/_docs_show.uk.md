<% if current_user %>
<pre>GET <%= api_v1_person_url(format: "json", id: "foo", key: current_user.api_key).gsub("foo", "[id]") %></pre>
<% else %>
<pre>GET <%= api_v1_person_url(format: "json", id: "id2", key: "api_key2").gsub("id2", "[id]").gsub("api_key2", "[api_key]") %></pre>
<% end %>

<% if current_user %>
Наприклад, запит 

<pre>GET <%= link_to api_v1_person_url(format: "json", id: 10001, key: current_user.api_key), api_v1_person_url(format: "json", id: 10001, key: current_user.api_key) %></pre>
<% end %>

видасть всю корисну і деталізовану інформацію, яка містить:

Параметр             | Опис
-------------------- | -----------------------------------------------------------
`rebellions`         | Кількість разів, коли вони голосували проти лінії фракції
`votes_attended`     | Загальну кількість голосувань депутата
`votes_possible`     | Кількість можливих голосувань, де вони могли б голосувати
`offices`            | не використовується
`policy_comparisons` | Сукупність політик, за який депутат міг голосувати і їх підрахований `agreement` бал в проміжку від 0 до 100. `voted` показує, чи вони колись голосували за законопроект з цієї політики.
