# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/mod_perl/mod_perl-1.27-r2.ebuild,v 1.8 2004/06/25 00:46:40 agriffis Exp $

inherit eutils

DESCRIPTION="A Perl Module for Apache"
SRC_URI="http://perl.apache.org/dist/${P}.tar.gz"
HOMEPAGE="http://perl.apache.org/"

SLOT="0"
LICENSE="Apache-1.1 as-is"
KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha"
IUSE="ipv6"

DEPEND="dev-lang/perl
	dev-perl/libwww-perl
	=net-www/apache-1*"

src_unpack() {
	unpack ${A}

	if has_version '>=apache-1.3.27-r4' && use ipv6; then
		# This patch originally came from
		# http://pasky.ji.cz/~pasky/dev/apache/mod_perl-1.27+ipv6.patch.
		# It allows mod_perl to correctly build with an IPv6-enabled
		# Apache (bug #6986).
		# Robert Coie <rac@gentoo.org> 2002.02.19

		cd ${S}; epatch ${FILESDIR}/${P}-ipv6.patch
	fi
}

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
	einfo "Execute \"ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config\""
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
