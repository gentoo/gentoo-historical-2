# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koffice-libs/koffice-libs-1.6.3.ebuild,v 1.1 2007/06/08 17:21:27 carlo Exp $

MAXKOFFICEVER=${PV}
KMNAME=koffice
KMMODULE=lib
inherit kde-meta eutils

DESCRIPTION="Shared KOffice libraries."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-data)
	virtual/python
	dev-lang/ruby"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

KMEXTRA="interfaces/
	plugins/
	tools/
	filters/olefilters/
	filters/xsltfilter/
	filters/generic_wrapper/
	kounavail/
	doc/api/
	doc/koffice/
	doc/thesaurus/"

KMEXTRACTONLY="
	kchart/kdchart/"

need-kde 3.5

src_unpack() {
	kde-meta_src_unpack unpack

	# Force the compilation of libkopainter.
	sed -i 's:$(KOPAINTERDIR):kopainter:' "${S}/lib/Makefile.am"

	if ! [[ $(xhost >> /dev/null 2>/dev/null) ]] ; then
		einfo "User ${USER} has no X access, disabling some tests."
		sed -e "s:SUBDIRS = . tests:SUBDIRS = .:" -i lib/store/Makefile.am || die "sed failed"
		sed -e "s:SUBDIRS = kohyphen . tests:SUBDIRS = kohyphen .:" -i lib/kotext/Makefile.am || die "sed failed"
	fi

	kde-meta_src_unpack makefiles
}

src_compile() {
	local myconf="--enable-scripting --with-pythonfir=/usr/$(get_libdir)/python${PYVER}/site-packages"
	kde-meta_src_compile
	if use doc; then
		make apidox || die
	fi
}

src_install() {
	kde-meta_src_install
	if use doc; then
		make DESTDIR="${D}" install-apidox || die
	fi
}
