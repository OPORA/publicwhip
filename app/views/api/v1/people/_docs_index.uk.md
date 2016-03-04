<% if current_user %>
<pre>GET <%= link_to api_v1_people_url(format: "json", key: current_user.api_key), api_v1_people_url(format: "json", key: current_user.api_key) %></pre>
<% else %>
<pre>GET <%= api_v1_people_url(format: "json", key: "foo").gsub("foo", "[api_key]") %></pre>
<% end %>

Цей запит надає базову інформацію про кожного народного депутата, який наразі є членом парламенту. Він включає їхні імена, обрання, партію.

Щоб отримати більш детальну інформацію про депутата, використовуй `id` для того, щоб робити наступне:
