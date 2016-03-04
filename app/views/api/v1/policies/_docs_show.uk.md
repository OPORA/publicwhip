<% if current_user %>
<pre>GET <%= api_v1_policy_url(format: "json", id: "foo", key: current_user.api_key).gsub("foo", "[id]") %></pre>
<% else %>
<pre>GET <%= api_v1_policy_url(format: "json", id: "id2", key: "api_key2").gsub("id2", "[id]").gsub("api_key2", "[api_key]") %></pre>
<% end %>

<% if current_user %>
Наприклад, запит

<pre>GET <%= link_to api_v1_policy_url(format: "json", id: 1, key: current_user.api_key), api_v1_policy_url(format: "json", id: 1, key: current_user.api_key) %></pre>
<% end %>

запит видає всі види корисної деталізованої інформації, що включають:

Параметр             | Опис
-------------------- | ------------------------------------------------------------------------
`id`                 | Унікальний визначник для голосування. Використовуй `id`, щоб отримати більше інформації про політику
`name`               | Коротка назва політики
`description`        | Більше інформації про цю політику, що означає політика
`provisional`        | `true` або `false`. Це проект політики, яка ще не завершена і не відображається за замовчуванням.
`policy_divisions`   | Сукупність олосувань, які включені до цієї політики. Кожне голосування має відповідне `vote` яке може бути `strong` і робить голосування дуже важливим
`people_comparisons` | Сукупність політик, за який депутат міг голосувати і їх підрахований `agreement` бал в проміжку від 0 до 100. `voted` показує, чи вони колись голосували за законопроект з цієї політики.
