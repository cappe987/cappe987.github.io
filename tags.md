---
layout: page
title: Tags 

---

<div class="page-content wc-container">
	<div class="post post-content">
		<h1>Tags</h1>  
		<ul>
			{% assign sorted = site.tags | sort %}
			{% for tag in sorted %}
			<li><a class="post-content" href="{{ '/tag/' | append:tag[0] | relative_url }}.html">{{ tag[0] }}</a></li>
			{% endfor %}
		</ul>
	</div>
</div>
