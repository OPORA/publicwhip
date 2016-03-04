<% if current_user %>
<pre>GET <%= link_to api_v1_divisions_url(format: "json", key: current_user.api_key), api_v1_divisions_url(format: "json", key: current_user.api_key) %></pre>
<% else %>
<pre>GET <%= api_v1_divisions_url(format: "json", key: "api_key2").gsub("api_key2", "[api_key]") %></pre>
<% end %>

Це повертає базову інформацію про **останні 200 голосувань,** що включають:

Параметр           | Опис
------------------ | -----------------------------------------------------------
`id`               | Унікальний визначник для голосування. Використовуй `id`, щоб отримати більше інформації про це голосування. 
`house`            | Whether this division took place in the House of Representatives or the Senate
`name`             | Скорочена назва
`date`             | Дата в форматі `yyyy-mm-dd`
`number`           | Перше голосування в визначений день. Кожне наступне голосування пронумеровано відповідно. 
`clock_time`       | Час голосування в форматі `hh:mm AM` або `hh:mm PM` чи `null` якщо не доступний
`aye_votes`        | Кількість депутатів, які проголосували “ЗА”
`no_votes`         | Кількість депутатів, які проголосували “Проти”
`possible_turnout` | The number of people who could potentially have voted based on the current number of members
`rebellions`       | The number of votes that went against the majority vote of their party
`edited`           | `true` якщо опис голосування був відредагований

Щоб отримати більше результатів та голосувань за певну дату, ти можеш 

<% if current_user %>
<pre>GET <%= link_to api_v1_divisions_url(format: "json", start_date: "2014-08-01", end_date: "2014-09-01", house: "rada", key: current_user.api_key), api_v1_divisions_url(format: "json", start_date: "2014-08-01", end_date: "2014-09-01", house: "senate", key: current_user.api_key) %></pre>
<% else %>
<pre>GET <%= api_v1_divisions_url(format: "json", start_date: "2014-08-01", end_date: "2014-09-01", house: "rada") + '&key=[api_key]' %></pre>
<% end %>

Again this will return **at most 200** results. It is your responsibility to ensure that you are
getting all the data you expect. In practise if you receive 200 results narrow the date range or just look
at the specific house you are interested in.
