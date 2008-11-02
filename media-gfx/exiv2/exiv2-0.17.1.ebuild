# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/exiv2/exiv2-0.17.1.ebuild,v 1.3 2008/11/02 07:03:26 vapier Exp $

inherit eutils

DESCRIPTION="EXIF and IPTC metadata C++ library and command line utility"
HOMEPAGE="http://www.exiv2.org/"
SRC_URI="http://www.exiv2.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc nls zlib xmp examples unicode"
IUSE_LINGUAS="de es fi fr pl ru sk"
IUSE="${IUSE} $(set -- ${IUSE_LINGUAS}; echo ${@/#/linguas_})"

RDEPEND="zlib? ( sys-libs/zlib )
	xmp? ( dev-libs/expat )
	nls? ( virtual/libintl )
	virtual/libiconv"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use unicode; then
		for i in doc/cmd.txt; do
			echo ">>> Converting "${i}" to UTF-8"
			iconv -f LATIN1 -t UTF-8 "${i}" > "${i}~" && mv -f "${i}~" "${i}" || rm -f "${i}~"
		done
	fi

	if use doc; then
		echo ">>> Updating doxygen config"
		doxygen &>/dev/null -u config/Doxyfile
	fi
}

src_compile() {
	local myconf="$(use_enable nls) $(use_enable xmp)"
	use zlib || myconf="${myconf} --without-zlib"  # plain 'use_with' fails
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
	if use doc; then
		emake doc || die "emake doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README doc/{ChangeLog,cmd.txt}
	use xmp && dodoc doc/{COPYING-XMPSDK,README-XMP,cmdxmp.txt}
	use doc && dohtml -r doc/html/.
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins samples/*.cpp
	fi
}

pkg_postinst() {
	ewarn
	ewarn "PLEASE PLEASE take note of this:"
	ewarn "Please make *sure* to run revdep-rebuild now"
	ewarn "Certain things on your system may have linked against a"
	ewarn "different version of exiv2 -- those things need to be"
	ewarn "recompiled. Sorry for the inconvenience!"
	ewarn
}
