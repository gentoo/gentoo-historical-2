# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/distcc/distcc-2.7.1.ebuild,v 1.1 2003/07/01 12:06:13 karltk Exp $

inherit eutils gcc flag-o-matic
[ `gcc-major-version` -eq 2 ] && filter-flags -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE

HOMEPAGE="http://distcc.samba.org/"
SRC_URI="http://distcc.samba.org/ftp/distcc/distcc-${PV}.tar.bz2"
DESCRIPTION="a program to distribute compilation of C code across several machines on a network"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~arm"
IUSE="gnome"

DEPEND=">=sys-apps/portage-2.0.46-r11
	>=sys-devel/gcc-config-1.3.1
	sys-apps/shadow
	dev-libs/popt"

RDEPEND="gnome? ( >=gnome-base/libgnomeui-2.2.0.1 )"

src_unpack() {
	unpack ${A}

	#this patch fixes the problem with portage reassigning $TMPDIR
	#and rendering the monitor programs useless, unless a rather
	#icky hack is used. now sudo -u portage distccmon-{gnome,text}
	#will work.  - Lisa
	cd ${S}/src
	epatch ${FILESDIR}/${PV}/001_fix_tmpdir.patch.gz
}

src_compile() {
	local myconf
	use gnome && myconf="--enable-gnome"

	econf ${myconf} || die "econf ${myconf} failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D%/}" install

	insinto /usr/share/doc/${PN}
	doins "${S}/survey.txt"

	exeinto /usr/bin
	doexe "${FILESDIR}/${PV}/distcc-config"

	insinto /etc/conf.d
	newins "${FILESDIR}/${PV}/conf" distccd

	exeinto /etc/init.d
	newexe "${FILESDIR}/${PV}/init" distccd

	# create and keep the symlink dir
	dodir /usr/lib/distcc/bin
	keepdir /usr/lib/distcc/bin

	# create the distccd pid directory
	dodir /var/run/distccd
	keepdir /var/run/distccd
}

pkg_preinst() {
	# non-/ installs don't require us to do anything here
	[ "${ROOT}" != "/" ] && return 0

	# stop daemon since script is being updated
	[ -n "$(pidof distccd)" -a -x /etc/init.d/distccd ] && \
		/etc/init.d/distccd stop

	# moved user creation and permissions to distcc-config script
	#  because of ROOT install requirements
}

pkg_postinst() {
	# handle DISTCC_HOSTS upgrade better
	local ENVFILE
	ENVFILE="${ROOT}etc/env.d/02distcc"
	[ ! -f "${ENVFILE}" ] && \
		ENVFILE="${ROOT}etc/env.d/04distcc"
	if [ -f "${ENVFILE}" ]
	then
		# save hosts to new file
		ROOT="${ROOT}" ${ROOT}usr/bin/distcc-config --set-hosts \
			$(egrep '^DISTCC_HOSTS' "${ENVFILE}" | sed 's,[^=]*=,,')
		# now remove from the file
		grep -v 'DISTCC_HOSTS' "${ENVFILE}" > "${ENVFILE}.new"
		mv "${ENVFILE}.new" "${ENVFILE}"
	fi

	if [ "${ROOT}" = "/" ]; then
		einfo "Installing links to native compilers..."
		/usr/bin/distcc-config --install-user
		/usr/bin/distcc-config --install-links
		/usr/bin/distcc-config --install-links "${CHOST}"
	else
		# distcc-config can *almost* handle ROOT installs itself
		#  but for now, but user must finsh things off
		ewarn "*** Installation is not complete ***"
		ewarn "You must run the following as root:"
		ewarn "  /usr/bin/distcc-config --install"
		ewarn "after booting or chrooting into ${ROOT}"
	fi
	einfo "To use distcc with **non-Portage** C compiling, add"
	einfo "/usr/lib/distcc/bin to your path before /usr/bin.  If you're"
	einfo "combining this with ccache, put the ccache path BEFORE distcc."
	einfo "Portage 2.0.46-r11+ will take advantage of distcc if you put"
	einfo "distcc into the FEATURES setting in make.conf and use" 
	einfo "distcc-config --set-hosts. Do NOT set CC=distcc or similar."
	echo ""
	einfo "To use the distccmon programs with Gentoo you should use this command:"
	einfo "   sudo -H -u portage distccmon-text OR sudo -H -u portage distccmon-gnome"
	ewarn "See \"http://wiki.dev.gentoo.org/gentoo/moin.cgi/UsingDistcc\" for information."
}

#pkg_prerm() {
#   # ztw - not sure if this is the right place
#	distcc-config --remove-links "${CHOST}"
#	distcc-config --remove-links
#}
