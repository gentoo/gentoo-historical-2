# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/setools/setools-1.3.ebuild,v 1.4 2004/05/04 20:37:01 pebenito Exp $

DESCRIPTION="SELinux policy tools"
HOMEPAGE="http://www.tresys.com/selinux_policy_tools.html"
SRC_URI="http://www.tresys.com/Downloads/selinux-tools/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="X gtk selinux"

DEPEND="sys-devel/bison
	sys-devel/flex
	dev-libs/libxml2
	dev-util/pkgconfig
	X? ( dev-lang/tk gtk? ( >=gnome-base/libglade-2.0 ) )"

RDEPEND="dev-libs/libxml2
	X? (
		dev-lang/tk
		>=dev-tcltk/bwidget-1.4.1
		gtk? ( >=gnome-base/libglade-2.0 )
	)"

src_unpack() {
	unpack ${A}
	cd ${S}

	# fix the Makefile to listen to portage CFLAGS
	sed -i -e "s:-O2:-O2 ${CFLAGS}:" ${S}/Makefile

	# fix for tcl/tk version
	has_version '=dev-lang/tk-8.4*' && \
		sed -i -e 's:8.3:8.4:' ${S}/Makefile

	# fix up the scripts we're going to install
	sed -i -e 's:local/selinux/::g' ${S}/seuser/seuseradd
	sed -i -e 's:local/selinux/::g' ${S}/seuser/seuserdel
	sed -i -e 's:local/selinux/::g' ${S}/seuser/seusermod

	# we will manually install policy
	sed -i -e "s: policy-install::g" ${S}/seuser/Makefile

	# fix up the file contexts
	sed -i -e 's:/usr/apol:/usr/share/setools:' ${S}/policy/seuser.fc

	# dont chcon
	sed -i -e '/chcon/d' ${S}/secmds/Makefile

	# set policy dir in seuser.conf
	sed -i -e '/^policy_dir/d' -e '/^user_file/d' ${S}/seuser/seuser.conf
	echo "policy_dir ${POLICYDIR}" >> ${S}/seuser/seuser.conf
	echo "user_file ${POLICYDIR}/users" >> ${S}/seuser/seuser.conf
}

src_compile() {
	cd ${S}

	# build command line tools
	make all-nogui || die "command line tools compile failed"

	if use X; then
		make apol sepcut seuserx \
			|| die "apol, sepcut, or seuserx compile failed"

		if use gtk; then
			make seaudit || die "seaudit compile failed."
		fi

	fi
}

src_install() {
	cd ${S}

	dodoc COPYING ChangeLog-setools README

	# some of the Makefiles are broken, and will fail
	# if ${D}/usr/bin is nonexistant
	dodir /usr/bin

	# command line tools
	make DESTDIR=${D} install-secmds \
		|| die "secmds install failed."

	if use X; then
		# graphical tools

		make DESTDIR=${D} install-apol install-sepcut \
			|| die "apol and sepcut install failed."

		if use gtk; then
			make DESTDIR=${D} install-seaudit \
				|| die "seaudit install failed."
		fi
	fi

	if use selinux; then
		if use X; then
			make DESTDIR=${D} install-seuserx \
				|| die "seuserx install failed."
		else
			make DESTDIR=${D} install-seuser \
				|| die "seuser install failed."
		fi

		insinto ${POLICYDIR}/domains/program
		doins ${S}/policy/seuser.te
		insinto ${POLICYDIR}/file_contexts/program
		doins ${S}/policy/seuser.fc
	fi
}

pkg_postinst() {
	einfo "Installed tools:"
	echo
	einfo "findcon"
	einfo "replcon"
	einfo "seinfo"
	einfo "sesearch"
	if use X; then
		einfo "apol"
		einfo "sepcut"
		use gtk && einfo "seaudit"
	fi
	if use selinux; then
		einfo "seuser"
		use X && einfo "seuserx"
		einfo "seuseradd"
		einfo "seuserdel"
		einfo "seusermod"
		echo
		einfo "A policy for the seuser program has been installed into"
		einfo "${POLICYDIR}.  Please reload your policy and relabel"
		einfo "setools:  rlpkg setools"
	fi
}
