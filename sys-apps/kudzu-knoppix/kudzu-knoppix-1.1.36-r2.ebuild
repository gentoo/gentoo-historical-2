# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kudzu-knoppix/kudzu-knoppix-1.1.36-r2.ebuild,v 1.1 2005/05/31 20:15:03 wolf31o2 Exp $

inherit eutils

MY_PV=${PV}-2
S=${WORKDIR}/kudzu-${PV}
DESCRIPTION="Knoppix version of the Red Hat hardware detection tools"
HOMEPAGE="http://www.knopper.net/"
SRC_URI="http://developer.linuxtag.net/knoppix/sources/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~alpha -sparc -mips ~ppc64"
IUSE="livecd nls minimal python"

RDEPEND="!livecd? ( ~minimal? (dev-libs/newt ) )
	dev-libs/popt
	sys-apps/hwdata-knoppix"
DEPEND="$RDEPEND
	!livecd? ( nls? ( sys-devel/gettext ) )
	!livecd? ( !minimal? ( sys-libs/slang ) )
	sys-apps/pciutils
	!livecd? ( !minimal? ( >=dev-libs/dietlibc-0.20 ) )
	!sys-apps/kudzu"

src_unpack() {
	unpack ${A}
	if ! use nls; then
		epatch "${FILESDIR}/${P}-nonls-v4.patch" || die "epatch failed"
	fi
}

src_compile() {
	# Fix the modules directory to match Gentoo layout.
	perl -pi -e 's|/etc/modutils/kudzu|/etc/modules.d/kudzu|g' *.*

	if use livecd; then
		emake libkudzu.a || die
	elif use minimal; then
		emake updfstab || die
	else
		emake || die
	fi

	if use x86 || use ppc; then
		if ! use livecd && ! use minimal; then
			cd ddcprobe || die
			emake || die
		fi
	fi
}

src_install() {
	if use livecd; then
		dodir /etc/sysconfig
		insinto /usr/include/kudzu
		doins *.h
		dolib.a libkudzu.a
	elif use minimal; then
		dodir /etc/sysconfig
		insinto /usr/include/kudzu
		doins *.h
		dolib.a libkudzu.a
		dosbin updfstab
		insinto /etc
		doins updfstab.conf*
	elif use python; then
		make install install-program DESTDIR=${D} || die "Install failed"
	else
		make installdata install-program DESTDIR=${D} || die "Install failed"
	fi

	if ! use livecd && ! use minimal; then
		# Init script isn't appropriate
		rm -rf ${D}/etc/rc.d
		# Add our own init scripts
		newinitd ${FILESDIR}/${PN/-knoppix}.rc ${PN/-knoppix} || die
		newconfd ${FILESDIR}/${PN/-knoppix}.conf.d ${PN/-knoppix} || die
	fi

	if use x86 || use ppc; then
		if ! use livecd && ! use minimal; then
			cd ${S}/ddcprobe || die
			dosbin ddcxinfo ddcprobe || die
		fi
	fi
}
