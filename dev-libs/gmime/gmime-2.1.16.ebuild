# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmime/gmime-2.1.16.ebuild,v 1.5 2005/10/05 15:11:32 ticho Exp $

inherit gnome2 eutils mono

IUSE="doc ipv6 mono"
DESCRIPTION="Utilities for creating and parsing messages using MIME"
SRC_URI="http://spruce.sourceforge.net/gmime/sources/v${PV%.*}/${P}.tar.gz"
HOMEPAGE="http://spruce.sourceforge.net/gmime/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND=">=dev-libs/glib-2
	doc? ( >=dev-util/gtk-doc-1.0 )
	mono? ( dev-lang/mono
			>=dev-dotnet/gtk-sharp-1.9.5 )"

DEPEND="dev-util/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	#db2html should be docbook2html
	sed -i -e 's:db2html:docbook2html -o gmime-tut:g' \
		docs/tutorial/Makefile.am docs/tutorial/Makefile.in \
		|| die "sed failed (1)"
	# Use correct libdir in pkgconfig file
	sed -i -e 's:^libdir.*:libdir=@libdir@:' \
		-e 's:^prefix=:exec_prefix=:' \
		mono/gmime-sharp.pc.in || die "sed failed (2)"
	# Fix doc targets (bug #97154)
	sed -i -e 's!\<\(tmpl-build.stamp\): !\1 $(srcdir)/tmpl/*.sgml: !' \
		gtk-doc.make docs/reference/Makefile.in || die "sed failed (3)"
}

src_compile() {
	econf \
	    `use_enable ipv6` \
		`use_enable mono` \
	    `use_enable doc gtk-doc` || die "configure failed"
	MONO_PATH=${S} emake -j1 || die
}

src_install() {
	make GACUTIL_FLAGS="/root ${D}/usr/$(get_libdir) /gacdir /usr/$(get_libdir) /package ${PN}" \
		DESTDIR=${D} install || die

	if use doc ; then
		docinto tutorial
		dodoc docs/tutorial/html/*
	fi

	# rename these two, so they don't conflict with app-arch/sharutils
	# (bug #70392)	Ticho, 2004-11-10
	mv ${D}/usr/bin/uuencode ${D}/usr/bin/gmime-uuencode
	mv ${D}/usr/bin/uudecode ${D}/usr/bin/gmime-uudecode
}

DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS PORTING README TODO doc/html/"
