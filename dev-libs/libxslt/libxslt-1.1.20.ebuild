# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.1.20.ebuild,v 1.3 2007/04/23 13:56:19 gustavoz Exp $

inherit libtool eutils python

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="crypt debug python"

DEPEND=">=dev-libs/libxml2-2.6.27
	crypt? ( >=dev-libs/libgcrypt-1.1.92 )
	python? ( dev-lang/python )"

SRC_URI="ftp://xmlsoft.org/${PN}/${P}.tar.gz"


src_unpack() {
	unpack "${A}"
	cd "${S}"

	# we still require the 1.1.8 patch for the .m4 file, to add
	# the CXXFLAGS defines <obz@gentoo.org>
	epatch "${FILESDIR}"/libxslt.m4-${PN}-1.1.8.patch

	# Patch Makefile to fix bug #99382 so that html gets installed in ${PF}
	sed -i -e 's:libxslt-$(VERSION):${PF}:' doc/Makefile.in

	epunt_cxx
	elibtoolize
}

src_compile() {
	# Always pass --with-debugger. It is required by third parties (see
	# e.g. bug #98345)
	local myconf="--with-debugger \
		$(use_with python)       \
		$(use_with crypt crypto) \
		$(use_with debug)        \
		$(use_with debug mem-debug)"

	econf ${myconf} || die "configure failed"

	# Patching the Makefiles to respect get_libdir
	# Fixes BUG #86756, please keep this.
	# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
	for x in $(find "${S}" -name "Makefile") ; do
		sed \
			-e "s|^\(PYTHON_SITE_PACKAGES\ =\ \/usr\/\).*\(\/python.*\)|\1$(get_libdir)\2|g" \
			-i ${x} \
			|| die "sed failed"
	done

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog Copyright FEATURES NEWS README TODO
}
