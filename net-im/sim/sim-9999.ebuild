# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/sim/sim-9999.ebuild,v 1.1 2007/12/14 17:11:21 pva Exp $

inherit subversion kde-functions eutils flag-o-matic

ESVN_REPO_URI="svn://svn.berlios.de/sim-im/trunk"
ESVN_PROJECT="sim-im"
ESVN_BOOTSTRAP="make -f ./admin/Makefile.common"

DESCRIPTION="Simple Instant Messenger (with KDE support). ICQ/AIM/Jabber/MSN/Yahoo."
HOMEPAGE="http://sim-im.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug kde spell ssl"

# kdebase-data provides the icon "licq.png"
RDEPEND="kde? ( kde-base/kdelibs
				|| ( kde-base/kdebase-data kde-base/kdebase ) )
		 !kde? ( $(qt_min_version 3)
				 spell? ( app-text/aspell ) )
		 ssl? ( dev-libs/openssl )
		 dev-libs/libxml2
		 dev-libs/libxslt
		 sys-libs/zlib
		 x11-libs/libXScrnSaver"

DEPEND="${RDEPEND}
	sys-devel/flex
	app-arch/zip
	x11-proto/scrnsaverproto"

pkg_setup() {
	if use kde ; then
		if use spell; then
			if ! built_with_use kde-base/kdelibs spell ; then
				ewarn "kde-base/kdelibs were merged without spell in USE."
				ewarn "Thus spelling will not work in sim. Please, either"
				ewarn "reemerge kde-base/kdelibs with spell in USE or emerge"
				ewarn 'sim with USE="-spell" to avoid this message.'
				ebeep
			fi
		else
			if built_with_use kde-base/kdelibs spell ; then
				ewarn 'kde-base/kdelibs were merged with spell in USE.'
				ewarn 'Thus spelling will work in sim. Please, either'
				ewarn 'reemerge kde-base/kdelibs without spell in USE or emerge'
				ewarn 'sim with USE="spell" to avoid this message.'
				ebeep
			fi
		fi
		if ! built_with_use kde-base/kdelibs arts ; then
			myconf="--without-arts"
		fi
	fi
}

src_unpack() {
	subversion_src_unpack

	if use kde ; then
	set-kdedir 3
	fi
}

src_compile() {
	filter-flags -fstack-protector -fstack-protector-all

	# Workaround for bug #119906
	append-flags -fno-stack-protector

	use kde || use spell || export DO_NOT_COMPILE="$DO_NOT_COMPILE plugins/spell"

	econf ${myconf} `use_enable kde` \
		  `use_with ssl` \
		  `use_enable debug` || die "econf failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed."
	dodoc TODO README AUTHORS.sim jisp-resources.txt ChangeLog
}
