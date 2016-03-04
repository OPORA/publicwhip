<% if current_user %>
<pre>GET <%= api_v1_division_url(format: "json", id: "foo", key: current_user.api_key).gsub("foo", "[id]") %></pre>
<% else %>
<pre>GET <%= api_v1_division_url(format: "json", id: "id2", key: "api_key2").gsub("id2", "[id]").gsub("api_key2", "[api_key]") %></pre>
<% end %>

<% if current_user %>
Наприклад

<pre>GET <%= link_to api_v1_division_url(format: "json", id: 2788, key: current_user.api_key), api_v1_division_url(format: "json", id: 2788, key: current_user.api_key) %></pre>
<% end %>

g Це повертає всю корисну і деталізовану інформації, що включає:

Параметр           | Опис
------------------ | -----------------------------------------------------------
`id`               | Унікальний визначник для голосування. Використовуй `id` , щоб отримати більше інформації про це голосування
`house`            | не використовується
`name`             | Скорочена назва
`date`             | Дата в форматі `yyyy-mm-dd`
`number`           | Перше голосування в визначений день. Кожне наступне голосування пронумеровано відповідно.
`clock_time`       | Час голосування в форматі `hh:mm AM` або `hh:mm PM` чи `null` якщо не доступний
`aye_votes`        | Кількість депутатів, які проголосували “ЗА”
`no_votes`         | Кількість депутатів, які проголосували “Проти”
`possible_turnout` | Кількість депутатів, які потенційно могли проголосувати
`rebellions`       | Кількість голосів, які були віддані проти лінії фракції
`edited`           | `true` якщо опис голосування був відредагований
`summary`          | Якщо `edited` є `false` this is a bit of text from the Hansard near to where the division took place. If `edited` is `true` then this is the latest version of the summary text written by contributors. It is formatted in Markdown.
`votes`            | An array of the votes cast by the members in this division
`policy_divisions` | An array of policies that are connected to this division including how they voted
`bills`            | Сукупність законопроектів, які пов'язані з голосуванням
