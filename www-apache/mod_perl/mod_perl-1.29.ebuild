# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_perl/mod_perl-1.29.ebuild,v 1.3 2005/11/12 16:25:09 mcummings Exp $

inherit eutils

DESCRIPTION="A Perl Module for Apache"
SRC_URI="http://perl.apache.org/dist/${P}.tar.gz"
HOMEPAGE="http://perl.apache.org"

SLOT="0"
LICENSE="Apache-1.1 as-is"
KEYWORDS="alpha ~amd64 ia64 ~ppc ppc64 sparc ~x86"

DEPEND="dev-lang/perl dev-perl/libwww-perl =net-www/apache-1*"

IUSE=""

src_unpack() {
	unpack ${A}

	cd ${S}
	for f in "apaci/mod_perl.config.sh" "apaci/libperl.module"
	do
		echo "tail -1 fix in ${f}"
		sed -i -e "s/tail -1/tail -n1/" ${f}
	done
}

src_compile() {
	perl Makefile.PL USE_APXS=1 \
		INSTALLDIRS=vendor \
		WITH_APXS=/usr/sbin/apxs EVERYTHING=1 PERL_DEBUG=1

	cp Makefile Makefile.orig
	sed -e "s:apxs_install doc_install:doc_install:" Makefile.orig > Makefile
	emake || die
}

src_install () {
	eval `perl '-V:installvendorarch'`
	eval `perl '-V:installvendorlib'`

	make \
		PREFIX=${D}/usr	\
		INSTALLVENDORARCH=${D}/${installvendorarch}	\
		INSTALLVENDORLIB=${D}/${installvendorlib}	\
		INSTALLVENDORMAN1DIR=${D}/usr/share/man/man1	\
		INSTALLVENDORMAN3DIR=${D}/usr/share/man/man3	\
		pure_vendor_install || die

	dodoc Changes CREDITS MANIFEST README SUPPORT ToDo
	dohtml -r ./
	# The following kludge is from the perl-module eclass to correct
	# the packlist file. packlist is used by other apps to determine
	# where to find parts of mod-perl
	for FILE in `find ${D} -type f -name "*.html" -o -name ".packlist"`; do
		sed -i -e "s:${D}:/:g" ${FILE}
	done


	cd apaci
	exeinto /usr/lib/apache-extramodules
	doexe libperl.so
}

pkg_postinst() {
	einfo
	einfo "Execute emerge --config =${PF}"
	einfo "to have your apache.conf auto-updated for use with this module."
	einfo "You should then edit your /etc/conf.d/apache file to suit."
	einfo
}

pkg_config() {
	${ROOT}/usr/sbin/apacheaddmod \
		${ROOT}/etc/apache/conf/apache.conf \
		extramodules/libperl.so mod_perl.c perl_module \
		define=PERL
	:;
}
