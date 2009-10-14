# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/backintime/backintime-0.9.26.ebuild,v 1.1 2009/10/14 13:28:10 bangert Exp $

EAPI="2"

DESCRIPTION="A simple backup system inspired by TimeVault and FlyBack, with a
GUI for GNOME and KDE4"
HOMEPAGE="http://backintime.le-web.org/"
SRC_URI="http://backintime.le-web.org/download/backintime/${P}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde gnome"

DEPEND="dev-lang/python
	net-misc/rsync[xattr]
	kde? (
		>=kde-base/kdelibs-4
		kde-base/pykde4
		kde-base/kompare
		kde-base/kdesu
		)
	gnome? ( gnome-base/libglade )
	dev-python/notify-python
	"

RDEPEND="${DEPEND}"

src_configure() {
	cd "${S}"/common
	econf

	if use kde ; then
		cd "${S}"/kde4
		econf
	fi

	if use gnome ; then
		cd "${S}"/gnome
		econf
	fi
}

src_compile() {
	cd "${S}"/common
	emake

	if use kde ; then
		cd "${S}"/kde4
		emake
	fi

	if use gnome ; then
		cd "${S}"/gnome
		emake
	fi
}

src_install() {
	cd "${S}"/common
	emake DESTDIR="${D}" install

	if use kde ; then
		cd "${S}"/kde4
		emake DESTDIR="${D}" install
		#use kdesu instead of kdesudo
		sed -i 's/kdesudo/kdesu/' \
			"${D}"//usr/share/applications/kde4/backintime-kde4-root.desktop
	fi

	if use gnome ; then
		cd "${S}"/gnome
		emake DESTDIR="${D}" install
	fi
}
