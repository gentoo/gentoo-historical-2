# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmikmod/libmikmod-3.1.10-r1.ebuild,v 1.5 2003/07/22 22:59:34 gmsoft Exp $

inherit gnuconfig
inherit flag-o-matic

IUSE="oss esd alsa"

S=${WORKDIR}/${P}
DESCRIPTION="A library to play a wide range of module formats"
SRC_URI="http://www.mikmod.org/files/libmikmod/${P}.tar.gz"
HOMEPAGE="http://www.mikmod.org/"

DEPEND=">=media-libs/audiofile-0.2.3
	alsa? ( >=media-libs/alsa-lib-0.5.9 )
	esd? ( >=media-sound/esound-0.2.19 )"

SLOT="0"
LICENSE="LGPL-2.1 | LGPL-2"
KEYWORDS="x86 amd64 hppa"

src_compile() {
	filter-flags -Os

	local myconf
	myconf="--enable-af" # include AudioFile driver

	[ -z `use esd` ]  || myconf="${myconf} --enable-esd"
	[ -z `use alsa` ] || myconf="${myconf} --enable-alsa"
	[ -z `use oss` ]  || myconf="${myconf} --enable-oss"

	use alpha && gnuconfig_update
	use amd64 && gnuconfig_update

	econf ${myconf} || die
	emake || die
}

src_install() {

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING* NEWS README TODO
	dohtml docs/*.html
}
