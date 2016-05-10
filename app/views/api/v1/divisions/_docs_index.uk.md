<% if current_user %>
<pre>GET <%= link_to api_v1_divisions_url(format: "json", key: current_user.api_key), api_v1_divisions_url(format: "json", key: current_user.api_key) %></pre>
<% else %>
<pre>GET <%= api_v1_divisions_url(format: "json", key: "api_key2").gsub("api_key2", "[api_key]") %></pre>
<% end %>

Цей запит повертає базову інформацію про **останні 250 голосувань,** що включають:

Параметр           | Опис
------------------ | -----------------------------------------------------------
`id`               | Унікальний визначник для голосування. Використовуй `id`, щоб отримати більше інформації про це голосування 
`house`            | Незмінний параметр `rada`
`name`             | Скорочена назва
`date`             | Дата в форматі `yyyy-mm-dd`
`number`           | Перше голосування в визначений день. Кожне наступне голосування пронумеровано відповідно
`clock_time`       | Час голосування в форматі `hh:mm AM` або `hh:mm PM`, чи `null`, якщо недоступний
`aye_votes`        | Кількість депутатів, які проголосували “ЗА”
`no_votes`         | Кількість депутатів, які проголосували “ПРОТИ”
`possible_turnout` | Кількість діючих депутатів на момент голосування
`rebellions`       | Загальна кількість голосів, які проти лінії фракції
`edited`           | `true`, якщо опис голосування був відредагований

Щоб отримати більше результатів та голосувань за певний проміжок часу, ти можеш 

<% if current_user %>
<pre>GET <%= link_to api_v1_divisions_url(format: "json", start_date: "2014-08-01", end_date: "2014-09-01", house: "rada", key: current_user.api_key), api_v1_divisions_url(format: "json", start_date: "2014-08-01", end_date: "2014-09-01", house: "rada", key: current_user.api_key) %></pre>
<% else %>
<pre>GET <%= api_v1_divisions_url(format: "json", start_date: "2014-08-01", end_date: "2014-09-01", house: "rada") + '&key=[api_key]' %></pre>
<% end %>

Цей запит видасть не більше **250 результатів голосувань**(це обмеження API). На твоїй відповідальності переконатися, що отримано всі очікувані дані. На практиці, якщо ти отримав **250 результатів голосувань**, то звузь часовий проміжок запиту.   

