# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_perl/mod_perl-1.27-r2.ebuild,v 1.2 2005/11/12 16:25:09 mcummings Exp $

inherit eutils

DESCRIPTION="A Perl Module for Apache"
SRC_URI="http://perl.apache.org/dist/${P}.tar.gz"
HOMEPAGE="http://perl.apache.org/"

SLOT="0"
LICENSE="Apache-1.1 as-is"
KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/libwww-perl
	=net-www/apache-1*"

src_compile() {
	perl Makefile.PL USE_APXS=1 \
		PREFIX=${D}/usr	\
		WITH_APXS=/usr/sbin/apxs EVERYTHING=1

	cp Makefile Makefile.orig
	sed -e "s:apxs_install doc_install:doc_install:" Makefile.orig > Makefile
	emake || die
}

src_install() {
	make \
		PREFIX=${D}/usr	\
		INSTALLMAN1DIR=${D}/usr/share/man/man1	\
		INSTALLMAN3DIR=${D}/usr/share/man/man3	\
		install || die

	dodoc Changes CREDITS MANIFEST README SUPPORT ToDo
	dohtml -r ./

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
