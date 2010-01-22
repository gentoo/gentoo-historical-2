# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfconf/xfconf-4.7.0.ebuild,v 1.2 2010/01/22 15:49:58 darkside Exp $

EAPI=2
inherit xfconf

DESCRIPTION="Xfce configuration daemon and utilities"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://xfce/src/xfce/xfconf/4.7/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug -perl profile"

RDEPEND=">=dev-libs/dbus-glib-0.72
	>=dev-libs/glib-2.12:2
	>=xfce-base/libxfce4util-4.6
	perl? ( dev-perl/glib-perl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	perl? ( dev-perl/extutils-depends
		dev-perl/extutils-pkgconfig )"

RESTRICT="test"

pkg_setup() {
	XFCONF="--disable-dependency-tracking
		--disable-static
		--with-perl-options=INSTALLDIRS=vendor
		$(use_enable perl perl-bindings)
		--disable-gtk-doc
		--disable-gtk-doc-html
		--disable-gtk-doc-pdf
		$(use_enable debug)
		$(use_enable debug checks)
		--with-html-dir=${EPREFIX}/usr/share/doc/${PF}/html"

	use profile && XFCONF="${XFCONF} --enable-profiling"

	DOCS="AUTHORS ChangeLog NEWS TODO"
}

src_compile() {
	emake OTHERLDFLAGS="${LDFLAGS}" || die
}

src_install() {
	xfconf_src_install

	if use perl; then
		# Prefix compat. In Gentoo Linux, defaults to ${D}
		[[ -z ${ED} ]] && local ED=${D}
		find "${ED}" -type f -name perllocal.pod -delete
		find "${ED}" -depth -mindepth 1 -type d -empty -delete
	fi
}
