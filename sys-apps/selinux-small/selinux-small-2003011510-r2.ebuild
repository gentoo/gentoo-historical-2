# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/selinux-small/selinux-small-2003011510-r2.ebuild,v 1.4 2003/03/25 17:16:11 method Exp $

DESCRIPTION="SELinux policy compiler and example policies"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz
	 http://www.coker.com.au/selinux/selinux-small/selinux-small_2003011510-7.diff.gz
	 http://www.coker.com.au/selinux/policy.tgz"

LICENSE="GPL-1"
SLOT="0"
S="${WORKDIR}/selinux"

# to easily specify that libsecure is in the workdir
LIBSECURE="-I${S}/libsecure/include -L${S}/libsecure/src"

KEYWORDS="x86"
IUSE="selinux"
DEPEND="<sys-libs/glibc-2.3.2
	>=sys-kernel/selinux-sources-2.4.20-r1"

pkg_setup() {
	use selinux || eend 1 "You must have selinux USE var"
}

src_compile() {
	ln -s /usr/src/linux ${WORKDIR}/lsm-2.4

	# fix up policy makefile
	cd ${WORKDIR}/policy
	sed -e 's:/usr/lib/selinux:/usr/flask:' < Makefile > Makefile.new
	mv -f Makefile.new Makefile

	cd ${S}

	epatch ${WORKDIR}/selinux-small_2003011510-7.diff
	epatch ${FILESDIR}/${P}-bison.diff

	einfo "Compiling checkpolicy"
	cd ${S}/module
		make all LSMVER=-2.4 || die "Checkpolicy compilation failed"

	einfo "Compiling libsecure"
	cd ${S}/libsecure
		make SE_INC=/usr/include/linux/flask \
			EXTRA_CFLAGS="${CFLAGS}" \
			|| die "libsecure compile failed."

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
			LDFLAGS="-L${S}/libsecure/src -lcrypt" \
			|| die "spasswd compile failed."
}

src_install() {
	# install policies
	dosbin ${S}/module/checkpolicy/checkpolicy
	dosbin ${S}/setfiles/setfiles
	mkdir -p ${D}/etc/security/selinux/src
	mv ${WORKDIR}/policy ${D}/etc/security/selinux/src

	insinto /usr/include
	doins ${S}/libsecure/include/*.h

	dolib.a ${S}/libsecure/src/libsecure.a

	dobin ${S}/libsecure/test/{avc_enforcing,avc_toggle,context_to_sid,sid_to_context,list_sids,chsid,lchsid,chsidfs,get_user_sids}
	dosbin ${S}/libsecure/test/load_policy
	dobin ${S}/utils/spasswd/{sadminpasswd,schfn,schsh,spasswd,suseradd,suserdel,svipw}
	dobin ${S}/utils/run_init/run_init
	dobin ${S}/utils/newrole/newrole

	doman ${S}/setfiles/setfiles.8
	doman ${S}/libsecure/man/man[12]/*
	doman ${S}/utils/newrole/newrole.1
	doman ${S}/utils/run_init/run_init.8
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
	make install || die "Policy installation failed"

	einfo "Loading policy"
	make load || die "Policy loading failed"

	einfo "Relabeling filesystems -- This will take a very long time!"
	make relabel || die "Relabeling failed (see above error messages)"
}
