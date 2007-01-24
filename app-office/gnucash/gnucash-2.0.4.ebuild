# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/gnucash/gnucash-2.0.4.ebuild,v 1.2 2007/01/24 20:49:00 seemant Exp $

inherit eutils gnome2

DOC_VER="2.0.1"

DESCRIPTION="A personal finance manager."
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-docs-${DOC_VER}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

IUSE="ofx hbci chipcard doc debug quotes nls mt940"

RDEPEND=">=dev-libs/glib-2.4.0
	=dev-scheme/guile-1.6*
	=dev-scheme/slib-3.1.1*
	>=sys-libs/zlib-1.1.4
	>=dev-libs/popt-1.5
	>=x11-libs/gtk+-2.4
	>=gnome-base/libgnomeui-2.4
	>=gnome-base/libgnomeprint-2.10
	>=gnome-base/libgnomeprintui-2.10
	>=gnome-base/libglade-2.4
	>=gnome-extra/gtkhtml-3.10.1
	>=dev-libs/libxml2-2.5.10
	=dev-libs/g-wrap-1.9.6*
	>=gnome-base/gconf-2
	>=app-text/scrollkeeper-0.3
	>=x11-libs/goffice-0.0.4
	gnome-extra/yelp
	ofx? ( >=dev-libs/libofx-0.7.0 )
	hbci? ( net-libs/aqbanking
		chipcard? ( sys-libs/libchipcard )
	)
	quotes? ( dev-perl/DateManip
		>=dev-perl/Finance-Quote-1.11
		dev-perl/HTML-TableExtract )
	app-text/docbook-xsl-stylesheets
	=app-text/docbook-xml-dtd-4.1.2*
	nls? ( dev-util/intltool )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen
		media-gfx/graphviz
		virtual/tetex )
	dev-util/pkgconfig"

pkg_setup() {
	built_with_use gnome-extra/libgsf gnome || die "gnome-extra/libgsf must be built with gnome"
	built_with_use x11-libs/goffice gnome || die "x11-libs/goffice must be built with gnome"
}

src_compile() {

	local myconf

	if use doc ; then
		myconf="${myconf} --enable-latex-docs"
	fi

	if use hbci ; then
		myconf="${myconf} --enable-hbci"

		if use mt940 ; then
			myconf="${myconf} --enable-mt940"
		fi
	fi


	econf \
		$(use_enable debug) \
		$(use_enable ofx) \
		$(use_enable doc doxygen) \
		$(use_enable doc html-docs) \
		$(use_enable doc dot) \
		--enable-locale-specific-tax \
		${myconf} || die "econf failed"

	MAKEOPTS="-j1"
	emake || die "emake failed"

	cd "${WORKDIR}/gnucash-docs-${DOC_VER}"
	econf || die "doc econf failed"
	emake || die "doc emake failed"
}

src_test() {
	einfo "Skipping tests because one of the upstream tests is broken"
	einfo "Please reference: https://bugs.gentoo.org/show_bug.cgi?id=146769#c1"
	einfo "We have a filed a bug upstream.  When that is resolved,"
	einfo "We will re-enable the tests."
}

# See http://bugs.gentoo.org/show_bug.cgi?id=132862 regarding gconf schema install

src_install() {
	gnome2_src_install || die "gnome2_src_install failed"
	dodoc AUTHORS ChangeLog* DOCUMENTERS HACKING INSTALL NEWS TODO README* doc/README*
	make_desktop_entry ${P} "GnuCash ${PV}" gnucash-icon.png "GNOME;Office;Finance"

	cd "${WORKDIR}/${PN}-docs-${DOC_VER}"
	make DESTDIR="${D}" \
		scrollkeeper_localstate_dir="${D}/var/lib/scrollkeeper" \
		install || die "doc install failed"
	rm -rf "${D}/var/lib/scrollkeeper"
}

pkg_postinst() {
	elog "Please note that postgresql support has been removed."
	elog "Please see: https://bugs.gentoo.org/show_bug.cgi?id=146769#c9"
	elog "for an explanation."
}
