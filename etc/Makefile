count:
	@echo -n 'languages: '; grep -E '^[a-z]{3}: ' languages | wc -l;
	@echo -n 'variants: '; grep -E '^[a-z]{3}: ' languages | awk -F: '{print $$3}' | wc -w;

chmod:
	chmod -R g+rX,o+rX . > /dev/null 2>&1

clean:
	find . -name .*.counts.json | xargs rm;
	find . -name .*.domains.zst | xargs rm;
	find . -name .*.urls.zst | xargs rm;
	find . -name .*.signatures.zst | xargs rm;

purge: clean
	find . -name .counts.json | xargs rm;
	find . -name .domains.zst | xargs rm;
	find . -name .urls.zst | xargs rm;
	find . -name .signatures.zst | xargs rm;
