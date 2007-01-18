# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bestcrypt/bestcrypt-1.6_p10-r1.ebuild,v 1.1 2007/01/18 22:09:12 alonbl Exp $

inherit flag-o-matic eutils linux-mod toolchain-funcs multilib

MY_PN="bcrypt"
MY_PV="${PV/_p/-}"
DESCRIPTION="commercially licensed transparent filesystem encryption"
HOMEPAGE="http://www.jetico.com/"
SRC_URI="http://www.jetico.com/linux/BestCrypt-${MY_PV}.tar.gz
	!x86? ( mirror://gentoo/bcrypt-rc6-serpent-c.diff.gz )
	x86? ( http://www.carceri.dk/files/bcrypt-rc6-serpent.diff.gz )"

LICENSE="bestcrypt"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/linux-sources"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

#get-version
MODULE_NAMES="bc(block:"${S}"/mod)
		bc_des(block:"${S}"/mod/des)
		bc_3des(block:"${S}"/mod/3des)
		bc_bf128(block:"${S}"/mod/bf128)
		bc_bf448(block:"${S}"/mod/bf448)
		bc_blowfish(block:"${S}"/mod/blowfish)
		bc_cast(block:"${S}"/mod/cast)
		bc_gost(block:"${S}"/mod/gost)
		bc_idea(block:"${S}"/mod/idea)
		bc_rijn(block:"${S}"/mod/rijn)
		bc_twofish(block:"${S}"/mod/twofish)
		bc_serpent(block:"${S}"/mod/serpent)
		bc_rc6(block:"${S}"/mod/rc6)"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use x86;
	then
		epatch "${WORKDIR}/bcrypt-rc6-serpent.diff"
	else
		epatch "${WORKDIR}/bcrypt-rc6-serpent-c.diff"
	fi
}

src_compile() {
	append-flags -fno-strict-aliasing
	filter-flags -fforce-addr

	emake -C kgsha CPP="$(tc-getCXX)" EXTRA_CXXFLAGS="${CXXFLAGS}" || die "library compile failed"
	emake -C kgsha256 CPP="$(tc-getCXX)"  EXTRA_CXXFLAGS="${CXXFLAGS}" || die "library compile failed"
	emake -C src CC="$(tc-getCC)"  EXTRA_CFLAGS="${CFLAGS} -I../kgsha256" || die "bctool compile failed"

	# Don't put stack protection in the kernel - it just is bad
	_filter-hardened -fstack-protector-all -fstack-protector

	emake  -C mod KERNEL_DIR=${KV_DIR} KEXT=${KV_OBJ} CC=$(tc-getCC) LD=$(tc-getLD) \
		AS=$(tc-getAS) CPP=$(tc-getCXX) EXTRA_CFLAGS="${CFLAGS}" \
		KVER=${KV_MAJOR}.${KV_MINOR} \
		|| die "compile failed"

	einfo "Modules compiled"
}

src_install() {
	linux-mod_src_install

	cd "${S}"
	dodir /etc
	cp etc/bc.conf "${D}"/etc/bc.conf

	dobin bin/bctool
	insinto /usr/bin
	for link in bcumount bcformat bcfsck bcnew bcpasswd bcinfo \
		bclink bcunlink bcmake_hidden bcreencrypt;
	do
		dosym bctool /usr/bin/${link}
	done

	# bug 107392
	insinto /usr/$(get_libdir)
	doins lib/libkgsha{,256}.so

	doman man/bctool.8
	newinitd "${FILESDIR}"/bcrypt3 bcrypt
	dodoc README HIDDEN_PART
}


pkg_postinst() {

	einfo "If you are using the serpent or rc6 encryption modules and have any problems,"
	einfo "please submit bugs to http://bugs.gentoo.org because these modules are not part"
	einfo "of the standard distribution of BestCrypt for Linux released by Jetico."
	einfo "For more information on these additional modules:"
	einfo "visit http://www.carceri.dk/index.php?redirect=other_bestcrypt"

	einfo
	ewarn "The BestCrypt drivers are not free - Please purchace a license from "
	ewarn "http://www.jetico.com/"

	einfo
	linux-mod_pkg_postinst
}
