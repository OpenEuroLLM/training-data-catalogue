count:
	@echo -n 'languages: '; grep -E '^[a-z]{3}: ' languages | wc -l;
	@echo -n 'variants: '; grep -E '^[a-z]{3}: ' languages | awk -F: '{print $$3}' | wc -w;
