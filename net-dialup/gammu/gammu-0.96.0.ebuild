# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gammu/gammu-0.96.0.ebuild,v 1.1 2004/06/17 01:39:08 st_lim Exp $

inherit eutils

DESCRIPTION="a fork of the gnokii project, a tool to handle your cellular phone"
SRC_URI="http://www.mwiacek.com/zips/gsm/gammu/older/${P}.tar.gz"
HOMEPAGE="http://www.mwiacek.com/gsm/gammu/gammu.html"

IUSE="nls bluetooth irda mysql"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
S=$WORKDIR/${P}

RDEPEND="irda? ( sys-kernel/linux-headers )
	mysql? ( dev-db/mysql )
	ssl? ( >=dev-libs/openssl-0.9.7d )
	bluetooth? ( net-wireless/bluez-libs )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	#epatch ${FILESDIR}/${P}-LastCalendar.patch
}

src_compile() {
	local myconf
	use bluetooth && myconf="${myconf} --with-bluedir=/usr/lib"
	use irda || myconf="${myconf} --disable-irdaat --disable-irdaphonet"
	econf \
		`use_enable nls` \
		--prefix=/usr \
		--enable-cb \
		--enable-7110incoming \
		--enable-6210calendar \
		${myconf} || die "configure failed"

	sed -e 's:-lz  -pthread:-lz  -lpthread -lssl:g' \
		-i ${S}/cfg/Makefile.cfg
	emake || die "make failed"
}

src_install () {
	make DESTDIR=${D} installlib || die "install failed"
	doman docs/docs/english/gammu.1
	mv ${D}/usr/share/doc/${PN} ${D}/usr/share/doc/${P}
}
