# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gnokii/gnokii-0.5.2-r1.ebuild,v 1.1 2003/10/01 00:04:33 liquidx Exp $

DESCRIPTION="a client that plugs into your handphone"
SRC_URI="http://freesoftware.fsf.org/download/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnokii.org"

IUSE="nls X bluetooth irda"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND="X? ( =x11-libs/gtk+-1.2* )
	bluetooth? ( net-wireless/bluez-libs )
	irda? (	sys-kernel/linux-headers )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-nounix98pty.patch
}

src_compile() {
	local myconf

	econf \
		`use_enable nls` \
		`use_with X x` \
	    --enable-security || die "configure failed"

	emake || die "make failed"
}

src_install () {
	make DESTDIR=${D} install || die "install failed"

	dodoc Docs/*
	docinto /usr/share/doc/${PF}/protocol
	dodoc Docs/protocol/*
	cp -r Docs/sample ${D}/usr/share/doc/${PF}/sample

	doman Docs/man/*

	dodir /etc
	sed -e 's:/usr/local/sbin:/usr/sbin:' ${S}/Docs/sample/gnokiirc > ${D}/etc/gnokiirc
}

pkg_postinst() {
	einfo "gnokii does not need it's own group anymore."
	einfo "Make sure the user that runs gnokii has read/write access to the device"
	einfo "which your phone is connected to. eg. chown <user> /dev/ttyS0"
}

pkg_postrm () {
	# leaving to clean up the old mess we used to leave behind
	# since we don't _really_ need suid gnokii, just the make sure
	# the use has the right perms
	groupdel gnokii
}
