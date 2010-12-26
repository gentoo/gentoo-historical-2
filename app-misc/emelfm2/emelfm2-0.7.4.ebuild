# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/emelfm2/emelfm2-0.7.4.ebuild,v 1.1 2010/12/26 13:33:42 ssuominen Exp $

EAPI=2
inherit eutils multilib toolchain-funcs

DESCRIPTION="A file manager that implements the popular two-pane design"
HOMEPAGE="http://emelfm2.net/"
SRC_URI="http://emelfm2.net/rel/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="acl fam gimp kernel_linux nls policykit spell udev"

RDEPEND=">=x11-libs/gtk+-2.12:2
	acl? ( sys-apps/acl )
	gimp? ( media-gfx/gimp )
	policykit? ( sys-auth/polkit )
	spell? ( app-text/gtkspell )
	udev? ( sys-fs/udisks
		dev-libs/dbus-glib )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

RESTRICT="test"

pkg_setup() {
	emel_use() {
		use ${1} && echo "${2}=1" || echo "${2}=0"
	}

	myemelconf=(
		DOCS_VERSION=1
		$(emel_use nls I18N)
		WITH_TRANSPARENCY=1
		$(emel_use kernel_linux WITH_KERNELFAM)
		$(emel_use spell EDITOR_SPELLCHECK)
		$(emel_use udev WITH_DEVKIT)
		$(emel_use gimp WITH_THUMBS)
		$(emel_use acl WITH_ACL)
		$(emel_use policykit WITH_POLKIT)
		STRIP=0
		)
}

src_compile() {
	tc-export CC
	emake LIB_DIR="/usr/$(get_libdir)" PREFIX="/usr" \
		${myemelconf[@]} || die
}

src_install() {
	emake LIB_DIR="${D}/usr/$(get_libdir)" PREFIX="${D}/usr" \
		${myemelconf[@]} install || die
	newicon icons/${PN}_48.png ${PN}.png
	prepalldocs
}
