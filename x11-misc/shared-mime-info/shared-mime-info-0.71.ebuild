# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/shared-mime-info/shared-mime-info-0.71.ebuild,v 1.3 2010/04/23 12:21:23 ssuominen Exp $

EAPI="3"

inherit fdo-mime

DESCRIPTION="The Shared MIME-info Database specification"
HOMEPAGE="http://freedesktop.org/wiki/Software/shared-mime-info"
SRC_URI="http://people.freedesktop.org/~hadess/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/glib-2.6
	>=dev-libs/libxml2-2.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-update-mimedb
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog HACKING NEWS README
	# in prefix, install an env.d entry such that prefix patch is used/added
	if use prefix; then
		echo "XDG_DATA_DIRS=\"${EPREFIX}/usr/share\"" > "${T}"/50mimeinfo
		doenvd "${T}"/50mimeinfo
	fi
}

pkg_postinst() {
	use prefix && export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	fdo-mime_mime_database_update
	elog
	elog "The database format has changed between 0.60 and 0.70."
	elog "You may need to update all your local databases and caches."
	elog "To do so, please run the following commands:"
	elog "(for each user) $ update-mime-database ~/.local/share/mime/"
	elog "(as root)       # update-mime-database ${EPREFIX}/usr/local/share/mime/"
	elog
}
