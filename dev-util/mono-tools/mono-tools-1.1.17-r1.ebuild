# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mono-tools/mono-tools-1.1.17-r1.ebuild,v 1.5 2007/03/05 03:56:52 genone Exp $

inherit eutils mono multilib autotools

DESCRIPTION="Set of useful Mono related utilities"
HOMEPAGE="http://www.mono-project.com/"
SRC_URI="http://www.go-mono.com/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="gtkhtml seamonkey"

RDEPEND="dev-lang/mono
		 >=dev-util/monodoc-${PV}
		 =dev-dotnet/gtk-sharp-2*
		 =dev-dotnet/glade-sharp-2*
		 =dev-dotnet/gconf-sharp-2*
		 gtkhtml? ( =dev-dotnet/gtkhtml-sharp-2* )
		 seamonkey? ( =dev-dotnet/gecko-sharp-0.11* )
		 !seamonkey? ( =dev-dotnet/gtkhtml-sharp-2* )"
DEPEND="${RDEPEND}
		sys-devel/gettext"

# Parallel build unfriendly
MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	if ! use gtkhtml && ! use seamonkey ; then
		elog "No browser selected, defaulting to gtkhtml"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# Make the browser optional
	epatch ${FILESDIR}/${PN}-1.1.17-html-renderer-fixes.diff

	# Install all our .dlls under $(libdir), not $(prefix)/lib
	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e 's:$(prefix)/lib:$(libdir):'                    \
			${S}/{asn1view/gtk,docbrowser,gnunit/src}/Makefile.am \
		|| die "sed failed"

		sed -i -e 's:$prefix/lib:@libdir@:' \
			${S}/docbrowser/monodoc.in      \
		|| die "sed failed"
	fi

	eautoreconf
}

src_compile() {
	local myconf="$(use_enable gtkhtml) $(use_enable seamonkey mozilla)"

	if ! use gtkhtml && ! use seamonkey ; then
		myconf="--enable-gtkhtml --disable-mozilla"
	fi

	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README
}
