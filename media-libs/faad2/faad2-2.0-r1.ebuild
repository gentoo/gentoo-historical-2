# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/faad2/faad2-2.0-r1.ebuild,v 1.2 2004/04/28 04:43:52 lv Exp $

inherit eutils libtool flag-o-matic

DESCRIPTION="The fastest ISO AAC audio decoder available, correctly decodes all MPEG-4 and MPEG-2 MAIN, LOW, LTP, LD and ER object type AAC files"
HOMEPAGE="http://faac.sourceforge.net/"
SRC_URI="mirror://sourceforge/faac/${PN}-${PV/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~alpha ~ia64 ~hppa ~mips"
IUSE="xmms"

RDEPEND="xmms? ( >=media-sound/xmms-1.2.7
	media-libs/id3lib )"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4.0.7
	sys-devel/automake
	sys-devel/autoconf"

S=${WORKDIR}/${PN}

DOCS="AUTHORS ChangeLog INSTALL NEWS README README.linux TODO"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-makefile-space.patch
	epatch ${FILESDIR}/${P}-configure-mpeg4ip.patch

	epatch ${FILESDIR}/${P}-gcc34.patch

	cd ${S}/common/mp4v2
	epatch ${FILESDIR}/mp4atom-sliver.patch

	cd ${S}/plugins/xmms/src
	epatch ${FILESDIR}/${P}-noext.patch

	# Get the xmms plugin to behave
	cd ${S}
	elibtoolize
}

src_compile() {
	# see #34392
	filter-flags -mfpmath=sse

	WANT_AUTOCONF=2.5 WANT_AUTOMAKE=1.7 sh ./bootstrap

	# mp4v2 needed for rhythmbox
	# drm needed for nothing but doesn't hurt

	econf \
		--with-mp4v2 \
		--with-drm \
		`use_with xmms` \
		|| die

	# emake causes xmms plugin building to fail
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc ${DOCS}

	# unneeded include, breaks building of apps
	# <foser@gentoo.org>
	dosed "s:#include <systems.h>::" /usr/include/mpeg4ip.h
}
