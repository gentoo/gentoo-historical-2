# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/predict/predict-2.2.3.ebuild,v 1.2 2007/01/26 11:43:04 armin76 Exp $

inherit toolchain-funcs

DESCRIPTION="Satellite tracking and orbital prediction."
HOMEPAGE="http://www.qsl.net/kd2bd/predict.html"
SRC_URI="http://www.amsat.org/amsat/ftp/software/Linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="xforms xplanet gtk nls"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="sys-libs/ncurses
	gtk? ( =x11-libs/gtk+-1.2* )
	xforms? ( x11-libs/xforms )
	xplanet? ( || ( x11-misc/xplanet x11-misc/xearth ) )"

src_compile() {
	# predict uses a ncurses based configure script
	# this is what it does if it was bash based ;)

	# set compiler string to a var so if compiler checks
	# can be added at a later date
	COMPILER="$(tc-getCC) ${CFLAGS}"

	# write predict.h
	echo "char *predictpath=\"/usr/share/predict/\";" > predict.h
	echo "char soundcard=1;" >> predict.h
	echo "char *version=\"${PV}\";" >> predict.h

	# compile predict
	einfo "compiling predict"
	${COMPILER} -L/$(get_libdir) -lm -lncurses -lpthread predict.c -o predict || \
		die "Failed compiling predict"

	# write vocalizer.h
	cd vocalizer
	echo "char *path={\"/usr/share/predict/vocalizer/\"};" > vocalizer.h

	# compile vocalizer
	einfo "compiling vocalizer"
	${COMPILER} vocalizer.c -o vocalizer || \
		die "Failed compiling vocalizer"

	einfo "compiling clients"

	# earthtrack
	if use xplanet; then
		einfo "compiling earthtrack"
		cd ${S}/clients/earthtrack
		# fix include path
		sed -e "s:/usr/local/share/xplanet:/usr/share/xplanet:" \
			-i earthtrack.c || die "Failed to fix xplanet paths"
		${COMPILER} -lm earthtrack.c -o earthtrack  || \
			die "Failed compiling earthtrack"
	fi

	# kep_reload
	einfo "compiling kep_reload"
	cd ${S}/clients/kep_reload
	${COMPILER} kep_reload.c -o kep_reload || \
		die "Failed compiling kep_reload"

	# map
	if use xforms; then
		einfo "compiling map"
		cd ${S}/clients/map
		TCOMP="${COMPILER} -I/usr/X11R6/include -L/usr/X11R6/$(get_libdir) -lforms -lX11 -lm map.c map_cb.c map_main.c -o map"
		${TCOMP} || die "Failed compiling map"
	fi

	# gsat
	if use gtk; then
		# note there are plugins for gsat but they are missing header files and wont compile
		use nls || myconf="--disable-nls"
		einfo "compiling gsat"
		cd ${S}/clients/gsat-*
		./configure --prefix=/usr ${myconf}
		cd src
		sed -e "s:#define DEFAULTPLUGINSDIR .*:#define DEFAULTPLUGINSDIR \"/usr/$(get_libdir)/gsat/plugins/\":" -i globals.h
		sed -e 's:int errno;::' -i globals.h
		cd ..
		emake || die "Failed compiling gsat"
	fi
}

src_install() {
	# install predict
	cd ${S}
	dobin predict ${FILESDIR}/predict-update
	dodoc CHANGES COPYING CREDITS HISTORY README NEWS
	dodoc docs/pdf/predict.pdf
	dodoc docs/postscript/predict.ps
	doman docs/man/predict.1

	insinto /usr/share/${PN}/default
	doins default/predict.*

	#install vocalizer
	exeinto /usr/bin
	cd vocalizer
	doexe vocalizer
	dodir /usr/share/predict/vocalizer
	insinto /usr/share/predict/vocalizer
	dosym  /usr/bin/vocalizer /usr/share/predict/vocalizer/vocalizer
	doins *.wav || die "Failed to install vocalizer *.wav files"

	# install clients

	# earthtrack
	if use xplanet; then
		cd ${S}/clients/earthtrack
		ln -s earthtrack earthtrack2
		dobin earthtrack earthtrack2
		mv README README.earthtrack && \
		dodoc README.earthtrack || \
			die "Failed to install earthtrack docs"
	fi

	# kep_reload
	cd ${S}/clients/kep_reload
	dobin kep_reload
	mv INSTALL INSTALL.kep_reload && \
	mv README README.kep_reload && \
	dodoc INSTALL.kep_reload README.kep_reload || \
		die "Failed to install kep_reload docs"

	# map
	if use xforms; then
		cd ${S}/clients/map
		dobin map
		for i in CHANGES README COPYING; do
			mv ${i} ${i}.map && dodoc ${i}.map || \
				die "Failed to install xforms docs"
		done
	fi

	# gsat
	if use gtk; then
		# the install seems broken so do manually...
		cd ${S}/clients/gsat-*
		dodir /usr/$(get_libdir)/gsat/plugins
		keepdir /usr/$(get_libdir)/gsat/plugins
		cd src
		dobin gsat
		cd ..
		for i in AUTHORS ABOUT-NLS COPYING ChangeLog INSTALL NEWS README Plugin_API; do
			mv ${i} ${i}.gsat && dodoc ${i}.gsat || \
				die "Failed to install gsat docs"
		done
	fi
}

pkg_postinst() {
	einfo "to use the clients the following line will"
	einfo "have to be inserted into /etc/services"
	einfo "predict    1210/udp"
	einfo "the port can be changed to anything"
	einfo "the name predict is what is needed to work"
	einfo "after that is set run 'predict -s'"
	einfo ""
	einfo "to get list of satellites run 'predict-update'"
	einfo "before running predict this script will also update"
	einfo "the list of satellites so they are up to date."
}
