# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/Embperl/Embperl-2.0_rc4.ebuild,v 1.3 2006/09/04 15:53:41 mcummings Exp $

inherit perl-module eutils

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Framework for building websites with Perl."
SRC_URI="mirror://cpan/authors/id/G/GR/GRICHTER/${MY_P}.tar.gz"
HOMEPAGE="http://perl.apache.org/embperl/"

IUSE="session apache2 modperl"
#xalan session
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ppc ~x86"
# tests bork at the moment but it seems to run
#SRC_TEST="do"

DEPEND="${DEPEND}
	modperl? ( apache2? ( >=www-apache/mod_perl-2.0.1 ) )
	dev-perl/libwww-perl
	session? ( >=dev-perl/Apache-Session-1.60
		dev-perl/Apache-SessionX )
	dev-perl/HTML-Parser
	virtual/perl-CGI
	dev-libs/libxml2
	>=dev-libs/libxslt-1.0.4"
	# Leftout until xalan is keyworded
	# xalan? ( dev-libs/xalan-c )


src_unpack() {

	unpack ${A}

	# patch the Makefile.PL to stop it asking questions
	cd ${S}; epatch ${FILESDIR}/${P}-Makefile.PL.patch
}

perl-module_src_prep() {

	perlinfo

	export PERL_MM_USE_DEFAULT=1

#	if use xalan; then
#		XALANPATH=""
#	else
#		XALANPATH="."
#	fi

	SRC_PREP="yes"
	einfo "Using ExtUtils::MakeMaker"
	XALANPATH="." EPHTTPD="/usr/sbin/apache2" perl Makefile.PL ${myconf} \
	PREFIX=/usr INSTALLDIRS=vendor DESTDIR=${D}
}

src_install () {
	# first run the perl install function
	perl-module_src_install

	# add a symlink for Embperl.so to make loading it easier
	dodir /usr/lib/apache2/modules
	dosym ${VENDOR_ARCH}/auto/${PN}/${PN}.so /usr/lib/apache2/modules/mod_embperl.so
	insinto /etc/apache2/modules.d
	doins ${FILESDIR}/78_mod_embperl.conf

}

pkg_postinst() {
	einfo
	einfo "To enable ${PN}, you need to edit your /etc/conf.d/apache2 file and"
	einfo "add '-D EMBPERL' to APACHE2_OPTS."
	einfo "Configuration file installed as"
	einfo "    /etc/apache2/modules.d/78_mod_embperl.conf"
	einfo "You may want to edit it before turning the module on in /etc/conf.d/apache2"
	einfo

}
