# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-sgml-utils/docbook-sgml-utils-0.6.14.ebuild,v 1.32 2012/04/04 03:27:54 floppym Exp $

inherit eutils

MY_PN=${PN/-sgml/}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Shell scripts to manage DocBook documents"
HOMEPAGE="http://sources.redhat.com/docbook-tools/"
SRC_URI="ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="jadetex"

DEPEND=">=dev-lang/perl-5
	app-text/docbook-dsssl-stylesheets
	app-text/openjade
	dev-perl/SGMLSpm
	~app-text/docbook-xml-simple-dtd-4.1.2.4
	~app-text/docbook-xml-simple-dtd-1.0
	app-text/docbook-xml-dtd
	~app-text/docbook-sgml-dtd-3.0
	~app-text/docbook-sgml-dtd-3.1
	~app-text/docbook-sgml-dtd-4.0
	~app-text/docbook-sgml-dtd-4.1
	jadetex? ( app-text/jadetex )
	userland_GNU? ( sys-apps/which )
	|| (
		www-client/lynx
		www-client/links
		www-client/elinks
		virtual/w3m )"
RDEPEND="${DEPEND}"

# including both xml-simple-dtd 4.1.2.4 and 1.0, to ease
# transition to simple-dtd 1.0, <obz@gentoo.org>

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${MY_P}-elinks.patch
}

src_install() {
	make DESTDIR="${D}" \
		htmldir="/usr/share/doc/${PF}/html" \
		install || die "Installation failed"

	if ! use jadetex ; then
		for i in dvi pdf ps ; do
			rm "${D}"/usr/bin/docbook2$i
			rm "${D}"/usr/share/sgml/docbook/utils-${PV}/backends/$i
			rm "${D}"/usr/share/man/man1/docbook2$i.1
		done
	fi
	dodoc AUTHORS ChangeLog NEWS README TODO
}
