# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/x86-chroot/x86-chroot-2006.0.ebuild,v 1.2 2006/08/27 09:16:28 blubb Exp $

inherit linux-info

DESCRIPTION="Provides a 32bit chroot for amd64 users"
HOMEPAGE="http://amd64.gentoo.org/"
SRC_URI="http://distfiles.gentoo.org/releases/x86/${PV}/stages/stage3-i686-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="-* ~amd64"
IUSE="X"

RDEPEND="sys-apps/setarch
	X? ( x11-apps/xhost )"

CONFIG_CHECK="IA32_EMULATION"
CHROOT_LOCATION=${CHROOT_LOCATION:-/opt/x86-chroot}

pkg_setup() {
	if [[ -e ${CHROOT_LOCATION} && -z ${IKNOWMYSHIT} ]] ; then
		eerror "ATTENTION! The location you are going to install the chroot to"
		eerror "already exists and probably contains a chroot. Re-merging ${PN}"
		eerror "will overwrite files in the chroot and likely result in a broken"
		eerror "chroot. If you still want to merge it, execute:"
		eerror ""
		eerror "export IKNOWMYSHIT=breakmychroot"
		die "Previous chroot instance found!"
	fi
	linux-info_pkg_setup
}

src_unpack() {
	cd ${WORKDIR}
	mkdir -p ".${CHROOT_LOCATION}"
	cd ".${CHROOT_LOCATION}"
	unpack ${A}
}

src_compile() {
	cat <<- EOF > "${WORKDIR}/${CHROOT_LOCATION}/etc/make.conf"
		CFLAGS="-O2 -march=athlon-xp -msse2 -pipe -fomit-frame-pointer"
		CHOST="i686-pc-linux-gnu"
		CXXFLAGS="\${CFLAGS}"
	EOF
	echo "env-update" >> "${WORKDIR}/${CHROOT_LOCATION}/root/.bashrc"
	echo "CHROOT_LOCATION=${CHROOT_LOCATION}" >	"${WORKDIR}/${CHROOT_LOCATION}/etc/conf.d/${PN}"
}

src_install() {
	mv ${WORKDIR}/* ${D}/ || die "moving chroot failed!"
	newinitd ${FILESDIR}/initd ${PN} || die "could not install init.d file!"
	mkdir -p "${D}/etc/conf.d"
	echo "CHROOT_LOCATION=${CHROOT_LOCATION}" > "${D}/etc/conf.d/${PN}" || die "could not install conf.d file!"
	dobin ${FILESDIR}/${PN} || die "couldn't install x86-chroot"
}

pkg_postinst() {
	einfo "Your chroot system is now installed. To do all the necessary setup"
	einfo "work, run '/etc/init.d/x86-chroot start'. To start a chroot session,"
	einfo "run 'x86-chroot'."
}

pkg_prerm() {
	[[ -f /etc/conf.d/${PN} ]] && source /etc/conf.d/${PN}
	ewarn "There are still files around in ${CHROOT_LOCATION}; make sure you
	manually"
	ewarn "remove that directory *after* checking the mounts for it"
}
