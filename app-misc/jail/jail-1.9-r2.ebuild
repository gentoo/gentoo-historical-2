# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/jail/jail-1.9-r2.ebuild,v 1.11 2010/01/01 18:56:47 ssuominen Exp $

inherit eutils flag-o-matic

S="${WORKDIR}/${PN}_1-9_stable"
DESCRIPTION="a tool that builds a chroot and configures all the required files, directories and libraries"
HOMEPAGE="http://www.jmcresearch.com/projects/jail/"
SRC_URI="mirror://sourceforge/jail/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND="dev-lang/perl
	dev-util/strace"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-gentoo.diff || die "failed to apply patch"
	epatch "${FILESDIR}"/wrongshell.patch || die "failed to apply patch"
	cd src
	epatch "${FILESDIR}"/multiuser-rsa.patch || die "failed to apply patch"
}

src_compile() {
	# configuration files should be installed in /etc not /usr/etc
	sed -i "s:\$4/etc:\${D}/etc:g" install.sh

	# the destination directory should be /usr not /usr/local
	cd "${S}"/src
	sed -i -e "s:usr/local:${D}/usr:g" \
		-e "s:^COPT =.*:COPT = -Wl,-z,no:g" Makefile

	# Below didn't work. Don't know why
	#append-ldflags -Wl,-z,now
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	cd "${S}"/src
	einstall

	# remove //var/tmp/portage/jail-1.9/image//usr from files
	FILES="/usr/bin/mkjailenv
		/usr/bin/addjailsw
		/usr/bin/addjailuser
		/etc/jail.conf
		/usr/lib/libjail.pm
		/usr/lib/arch/generic/definitions
		/usr/lib/arch/generic/functions
		/usr/lib/arch/linux/definitions
		/usr/lib/arch/linux/functions
		/usr/lib/arch/freebsd/definitions
		/usr/lib/arch/freebsd/functions
		/usr/lib/arch/irix/definitions
		/usr/lib/arch/irix/functions
		/usr/lib/arch/solaris/definitions
		/usr/lib/arch/solaris/functions"

	for f in "${D}${FILES}"; do
		# documentation says funtion 'dosed' is supposed to do this, but didn't know how to make it work :'(
		# dosed ${file} || die "error in dosed"
		sed -i "s:/${D}/usr:/usr:g" ${f}
	done

	cd "${D}"/usr/lib
	sed -i "s:/usr/etc:/etc:" libjail.pm

	cd "${S}"/doc
	dodoc CHANGELOG INSTALL README SECURITY VERSION
}
