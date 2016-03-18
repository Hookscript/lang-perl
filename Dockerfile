FROM perl:5.22.1

# do CPAN dependencies first so expensive module installations
# are more likely to be cached by Docker on repeat builds.
ADD cpanfile /tmp/
RUN cpanm -n --installdeps /tmp/

ADD lib/Hookscript.pm /usr/local/lib/perl5/site_perl/5.22.1/

ADD compile /bin/
ADD run /bin/
