count:
	@echo -n 'languages: '; grep -E '^[a-z]{3}: ' languages | wc -l;
	@echo -n 'variants: '; grep -E '^[a-z]{3}: ' languages | awk -F: '{print $$3}' | wc -w;

chmod:
	chmod -R g+rX,o+rX . > /dev/null 2>&1

checksum:
	for i in *_*/*.jsonl.zst; do \
	  j=$$(dirname $${i})/.$$(basename $${i} .zst).md5; \
	  if [ ! -f $${j} ]; then echo $${i}; md5sum $${i} > $${j}; fi; \
	done
	for i in *_*; do if [ -d $${i} ]; then cat $${i}/.*.jsonl.md5 > $${i}.md5; fi; done

clean:
	find . -name .\*.counts.json | xargs rm;
	find . -name .\*.domains.zst | xargs rm;
	find . -name .\*.urls.zst | xargs rm;
	find . -name .\*.signatures.zst | xargs rm;

purge: clean
	find . -name .counts.json | xargs rm;
	find . -name .domains.zst | xargs rm;
	find . -name .urls.zst | xargs rm;
	find . -name .signatures.zst | xargs rm;
