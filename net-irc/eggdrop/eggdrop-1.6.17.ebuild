# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/eggdrop/eggdrop-1.6.17.ebuild,v 1.6 2004/11/11 19:40:40 kloeri Exp $

inherit eutils

MY_P=eggdrop${PV}
PATCHSET_V=1.0

DESCRIPTION="An IRC bot extensible with C or Tcl."
HOMEPAGE="http://www.eggheads.org/"
SRC_URI="ftp://ftp.eggheads.org/pub/eggdrop/source/1.6/${MY_P}.tar.gz
	http://gentoo.mirror.at.stealer.net/files/${P}-patches-${PATCHSET_V}.tar.bz2"
KEYWORDS="x86 sparc ~mips ~ia64 ~amd64 ppc alpha"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug static mysql postgres ssl"

DEPEND="dev-lang/tcl
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )
	ssl? ( dev-libs/openssl )"

S=${WORKDIR}/${MY_P}

src_unpack()  {
	unpack ${A}
	cd ${S}

	EPATCH_SUFFIX="patch" epatch || die "epatch failed"
}

src_compile() {
	local target=""

	use mysql    || ( echo mysql ; echo mystats ) >>disabled_modules
	use postgres || echo pgstats >>disabled_modules

	econf $(use_with ssl) || die "./configure failed"

	make config || die "module config failed"

	if use static && use debug; then
		target="sdebug"
	elif use static; then
		target="static"
	elif use debug; then
		target="debug"
	fi

	emake -j1 CFLGS="${MY_CFLAGS}" ${target} || die "emake ${target} failed"
}

src_install() {
	local a b
	make DEST=${D}/opt/eggdrop install || die "make install failed"

	for a in doc/*
	do
		[ -f $a ] && dodoc $a
	done

	cd src/mod
	for a in *.mod
	do
		for b in README UPDATES INSTALL TODO CONTENTS
		do
			[ -f $a/$b ] && newdoc $a/$b $b.$a
		done
	done
	cd ${S}

	dodoc \
		src/mod/botnetop.mod/botnetop.conf \
		src/mod/gseen.mod/gseen.conf \
		src/mod/mc_greet.mod/mc_greet.conf \
		src/mod/stats.mod/stats.conf \
		src/mod/away.mod/away.doc \
		src/mod/rcon.mod/matchbot.tcl \
		src/mod/mystats.mod/tools/mystats.{conf,sql} \
		src/mod/pgstats.mod/tools/pgstats.{conf,php,sql} \
		text/motd.*

	for a in doc/html/*
	do
		[ -f $a ] && dohtml $a
	done

	dobin ${FILESDIR}/eggdrop-installer
	doman doc/man1/eggdrop.1
}

pkg_postinst() {
	einfo
	einfo "NOTE: IPV6 support has been dropped by upstream maintainers."
	einfo "Please run /usr/bin/eggdrop-installer to install your eggdrop bot."
	einfo
}
