# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/selinux-small/selinux-small-2003040709-r3.ebuild,v 1.3 2003/06/21 21:19:40 drobbins Exp $

DESCRIPTION="SELinux libraries and policy compiler"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz
	 http://www.coker.com.au/selinux/selinux-small/selinux-small_${PV}-5.diff.gz"

LICENSE="GPL-2"
SLOT="0"
S="${WORKDIR}/selinux"

# to easily specify that libsecure is in the workdir, and we want to use pam
LIBSECURE="-I${S}/libsecure/include -L${S}/libsecure/src -DUSE_PAM"

KEYWORDS="x86 amd64 ppc alpha sparc"
IUSE="selinux"
DEPEND="<sys-libs/glibc-2.3.2
	sys-devel/flex
	sys-libs/pam
        || (
                >=sys-kernel/selinux-sources-2.4.20-r1
                >=sys-kernel/hardened-sources-2.4.20-r1
           )"

RDEPEND="<sys-libs/glibc-2.3.2
	|| (
                >=sys-kernel/selinux-sources-2.4.20-r1
                >=sys-kernel/hardened-sources-2.4.20-r1
           )
	dev-tcltk/expect
	>=sys-apps/selinux-base-policy-20030522"

pkg_setup() {
	use selinux || eend 1 "You must have selinux in USE."

	if [ ! -f /usr/src/linux/security/selinux/ss/ebitmap.c ]; then
		eerror "The /usr/src/linux symlink appears to be incorrect.  It must"
		eerror "be pointing to a selinux-sources or hardened-sources kernel"
		eerror "for selinux-small to compile.  If the symlink is correct, the"
		eerror "kernel sources may be damaged or incomplete, and will need to"
		eend 1 "be remerged.  Please fix and retry."
	fi
}

src_compile() {
	ln -s /usr/src/linux ${WORKDIR}/lsm-2.4

	cd ${S}

	epatch ${WORKDIR}/selinux-small_${PV}-5.diff
	epatch ${FILESDIR}/${P}-bison.diff

	cd ${S}/setfiles
	epatch ${FILESDIR}/${P}-setfiles.diff

	einfo "Compiling checkpolicy"
	cd ${S}/module
		make all LSMVER=-2.4 || die "Checkpolicy compilation failed"

	einfo "Compiling libsecure"
	cd ${S}/libsecure
		make SE_INC=/usr/include/linux/flask \
			EXTRA_CFLAGS="${CFLAGS}" \
			|| die "libsecure compile failed."
	cd ${S}/devfsd
		mv devfsd-conflet selinux-small
		make CFLAGS="${CFLAGS} ${LIBSECURE}" \
			LDFLAGS="-L${S}/libsecure/src" \
			|| die "devfsd compile failed."

	einfo "Compiling utilities"
	cd ${S}/setfiles
		make CFLAGS="${CFLAGS} ${LIBSECURE}" \
			LDFLAGS="-L${S}/libsecure/src" setfiles \
			|| die "setfiles compile failed."
	cd ${S}/utils/newrole
		make CFLAGS="${CFLAGS} ${LIBSECURE} -lcrypt" \
			|| die "newrole compile failed."
	cd ${S}/utils/run_init
		make CFLAGS="${CFLAGS} ${LIBSECURE} -lcrypt" \
			|| die "run_init compile failed."
	cd ${S}/utils/spasswd
		make CFLAGS="${CFLAGS} ${LIBSECURE}" \
			LDFLAGS="-L${S}/libsecure/src -lcrypt -static" \
			|| die "spasswd compile failed."
}

src_install() {
	# install policy stuff
	dosbin ${S}/module/checkpolicy/checkpolicy
	dosbin ${S}/setfiles/setfiles

	insinto /usr/include
	doins ${S}/libsecure/include/*.h

	insinto /etc/devfs.d
	doins ${S}/devfsd/selinux-small

	dolib.a ${S}/libsecure/src/libsecure.a
	dobin ${S}/libsecure/test/{avc_enforcing,avc_toggle,context_to_sid,sid_to_context,list_sids,chsid,lchsid,chsidfs,get_user_sids}
	dosbin ${S}/libsecure/test/load_policy
	dobin ${S}/utils/spasswd/{sadminpasswd,schfn,schsh,spasswd,suseradd,suserdel,svipw}
	dobin ${S}/utils/run_init/run_init
	dosbin ${S}/utils/run_init/open_init_pty
	dobin ${S}/utils/newrole/newrole
	dosbin ${FILESDIR}/rlpkg

	doman ${S}/setfiles/setfiles.8
	doman ${S}/libsecure/man/man[12]/*
	doman ${S}/utils/newrole/newrole.1
	doman ${S}/utils/run_init/run_init.8

	exeinto /lib/devfsd
	doexe ${S}/devfsd/devfsd-se.so

	# install pam stuff
	insinto /etc/pam.d
	doins ${FILESDIR}/{newrole,run_init}
}

pkg_postinst() {
	einfo
	einfo "To recompile the policy and relabel the filesystem simply run:"
	einfo "ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	einfo
}

pkg_config() {
	cd /etc/security/selinux/src/policy

	einfo "Compiling policy"
	make policy || die "Policy compile failed (see above error messages)"

	einfo "Installing policy"
	make install || die "Policy install failed (see above error messages)"

	einfo "Loading policy"
	make load || die "Policy loading failed (see above error messages)"

	einfo "Relabeling filesystems -- This will take a very long time!"
	make relabel || die "Relabeling failed (see above error messages)"
}
