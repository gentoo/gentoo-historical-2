# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/pvm/pvm-3.4.5-r2.ebuild,v 1.11 2009/09/23 20:43:23 patrick Exp $

inherit eutils multilib

MY_P="${P/-}"
DESCRIPTION="PVM: Parallel Virtual Machine"
HOMEPAGE="http://www.epm.ornl.gov/pvm/pvm_home.html"
SRC_URI="ftp://ftp.netlib.org/pvm3/${MY_P}.tgz "
IUSE="crypt"
DEPEND=""
RDEPEND=""
SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ia64 ppc ppc64 ~sparc x86"
S="${WORKDIR}/${MY_P%%.*}"

src_unpack() {
	unpack ${A}
	cd ${S}
	# Patches from Red Hat
	epatch ${FILESDIR}/${P}-envvars.patch || die
	epatch ${FILESDIR}/${P}-strerror.patch || die
	epatch ${FILESDIR}/${P}-extra-arches.patch || die
	epatch ${FILESDIR}/${P}-x86_64-segfault.patch || die
	epatch ${FILESDIR}/${P}-gcc-4.1.patch || die
	epatch ${FILESDIR}/${P}-bug_147337.patch || die

# setup def files for other archs
	cp conf/LINUX64.def conf/LINUXPPC64.def
	cp conf/LINUX64.m4 conf/LINUXPPC64.m4

	epatch ${FILESDIR}/${P}-ppc64.patch || die

# s390 should go in this list if there is ever interest
# Patch the 64bit def files to look in lib64 dirs as well for libraries.
	for I in 64 PPC64; do
		sed -i -e "s|ARCHDLIB	=|ARCHDLIB	= -L/usr/lib64 -L/usr/X11R6/lib64 |" conf/LINUX${I}.def || die "Failed to fix 64-bit"
		sed -i -e "s|ARCHLIB	=|ARCHLIB	= -L/usr/lib64 -L/usr/X11R6/lib64 |" conf/LINUX${I}.def || die "Failed to fix 64-bit"
	done

	if use crypt; then
		for i in ${S}/conf/LINUX*def; do
			sed -i.orig -e '/^ARCHCFLAGS/s~/usr/bin/rsh~/usr/bin/ssh~' "${i}" ||
			die "Failed to set ssh instead of rsh"
		done
	fi

}

src_compile() {
	unset PVM_ARCH

	export PVM_ROOT="${S}"
	emake || die
}

src_install() {
	dodir /usr/share/man
	rm man/man1 -fr
	mv man/man3 ${D}/usr/share/man/

	dodoc Readme

	#installs the rest of pvm
	dodir /usr/share/pvm3
	cp -r * ${D}/usr/share/pvm3
	dodir /usr/bin

	# (#132711) Symlink to the right spot on multilib systems
	local linuxdir
	if [[ $(get_libdir) = lib64 ]]; then
		linuxdir="LINUX64"
	else
		linuxdir="LINUX"
	fi
	ln -s /usr/share/pvm3/lib/${linuxdir}/pvm ${D}/usr/bin/pvm
	ln -s /usr/share/pvm3/lib/${linuxdir}/pvmd3 ${D}/usr/bin/pvmd3
	ln -s /usr/share/pvm3/lib/${linuxdir}/pvmgs ${D}/usr/bin/pvmgs

	#environment variables:
	echo PVM_ROOT=/usr/share/pvm3 > ${T}/98pvm
	echo PVM_ARCH=$(${D}/usr/share/pvm3/lib/pvmgetarch) >> ${T}/98pvm
	doenvd ${T}/98pvm
}

pkg_postinst() {
	ewarn "Environment variables have changed. Do not forget to run etc-update,"
	ewarn "reboot or perform . /etc/profile before using pvm!"
}
